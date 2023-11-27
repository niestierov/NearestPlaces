//
//  MapPlacesViewController.swift
//  NearestPlaces
//
//  Created by Denys Niestierov on 09.11.2023.
//

import UIKit
import GoogleMaps

protocol MapPlacesView: AnyObject {
    var locationService: LocationService { get }
    
    func addMarker(for place: Place)
    func showAlert(
        title: String,
        message: String,
        actions: [AlertButtonAction]
    )
}

final class MapPlacesViewController: UIViewController {
    private enum Constant {
        static let defaultVerticalInset: CGFloat = 75
        static let defaultHorizontalInset: CGFloat = 10
        static let defaultZoom: Float = 12
        static let messageUnknownError = "It seems like there's been an unknown error. You can try to download the data again."
        
        enum ListPlacesButton {
            static let shadowOpacity: Float = 0.3
            static let shadowRadius: CGFloat = 2
            static let width: CGFloat = 56
            static let image = "list.clipboard"
            static let shadowOffset = CGSize(width: 0, height: 2)
        }
    }
    
    // MARK: - Properties -
    
    private let presenter: MapPlacesPresenter!
    private(set) var locationService: LocationService
    
    // MARK: - UI Components -
    
    private lazy var mapView: GMSMapView = {
        let map = GMSMapView()
        map.settings.myLocationButton = true
        map.isMyLocationEnabled = true
        map.translatesAutoresizingMaskIntoConstraints = false
        return map
    }()
    private lazy var listPlacesButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(
            self,
            action: #selector(showPlacesList),
            for: .touchUpInside
        )
        let image = UIImage(systemName: Constant.ListPlacesButton.image)
        button.setImage(image, for: .normal)
        button.backgroundColor = .white
        button.tintColor = .darkGray
        button.applyShadow(
            shadowOpacity: Constant.ListPlacesButton.shadowOpacity,
            shadowOffset: Constant.ListPlacesButton.shadowOffset,
            shadowRadius: Constant.ListPlacesButton.shadowRadius
        )
        return button
    }()
    
    // MARK: - Life Cycle -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        setupMapView()
        setupListPlacesButton()
        setupLocationService()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        listPlacesButton.setRoundedCornerRadius()
    }
    
    init(presenter: MapPlacesPresenter, locationService: LocationService) {
        self.presenter = presenter
        self.locationService = locationService
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private -

private extension MapPlacesViewController {
    func setupNavigationBar() {
        navigationController?.isNavigationBarHidden = true
    }
    
    func setupLocationService() {
        locationService.delegate = self
        
        locationService.verifyLocationPermissions()
        
        locationService.handleAuthorizationDenied = { [weak self] in
            self?.presenter.handleAuthorizationStatusDenied()
        }
        locationService.handleAuthorizationUnknown = { [weak self] in
            self?.presenter.createTryAgainAlert(message: Constant.messageUnknownError) {
                self?.locationService.verifyLocationPermissions()
            }
        }
    }
    
    func setupMapView() {
        view.addSubview(mapView)
        
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.topAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func setupListPlacesButton() {
        view.addSubview(listPlacesButton)
        
        NSLayoutConstraint.activate([
            listPlacesButton.bottomAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                constant: -Constant.defaultVerticalInset
            ),
            listPlacesButton.trailingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                constant: -Constant.defaultHorizontalInset
            ),
            listPlacesButton.widthAnchor.constraint(
                equalToConstant: Constant.ListPlacesButton.width
            ),
            listPlacesButton.heightAnchor.constraint(
                equalTo: listPlacesButton.widthAnchor
            ),
        ])
    }
    
    @objc func showPlacesList() {
        presenter.placesListButtonTapped()
    }
    
    func updateMap(
        location: CLLocationCoordinate2D,
        zoom: Float = Constant.defaultZoom
    ) {
        let camera = GMSCameraPosition.camera(withTarget: location, zoom: zoom)
        mapView.camera = camera
        
        presenter.fetchPlaces(location: location)
    }
}

// MARK: - MapPlacesViewProtocol -

extension MapPlacesViewController: MapPlacesView {
    func addMarker(for place: Place) {
        let latitude = place.location.latitude
        let longitude = place.location.longitude
        let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        
        let marker = GMSMarker(position: location)
        
        let name = place.displayName?.text ?? ""
        let address = place.formattedAddress ?? ""
        
        marker.title = name
        marker.snippet = address
        marker.map = mapView
    }
}

// MARK: - LocationServiceDelegate -

extension MapPlacesViewController: LocationServiceDelegate {
    func didUpdateLocation(location: CLLocationCoordinate2D) {
        updateMap(location: location)
    }
}

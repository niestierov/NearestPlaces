//
//  MapPlacesViewController.swift
//  NearestPlaces
//
//  Created by Denys Niestierov on 09.11.2023.
//

import UIKit
import GoogleMaps

final class MapPlacesViewController: UIViewController {
    private enum Constant {
        static let defaultVerticalInset: CGFloat = 75
        static let defaultHorizontalInset: CGFloat = 10
        static let listPlacesButtonWidth: CGFloat = 56
        static let listPlacesButtonImage = "list.clipboard"
        static let defaultZoom: Float = 12
        
        enum Alert {
            static let actionTitleCancel = "Cancel"
            static let actionTitleSettings = "Open Settings"
            static let titleAuthorizationDenied = "Location Services Disabled"
            static let messageAuthorizationDenied = "You should enable location services in the settings for the program to work correctly."
            static let messageUnknownError = "It seems like there's been an unknown error. You can try to download the data again."
            static let defaultTryAgainAlertTitle = "Error"
            static let defaultTryAgainActionTitle = "Try Again"
            static let defaultCancelTitle = "Cancel"
        }
    }
    
    // MARK: - Properties -
    
    private let locationService = LocationService()
    private let networkService = NetworkService()
    private var placesList: [Place] = []
    
    // MARK: - UIComponents -
    
    private var mapView: GMSMapView = {
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
            action: #selector(routeToListPlaces),
            for: .touchUpInside
        )
        let image = UIImage(systemName: Constant.listPlacesButtonImage)
        button.setImage(image, for: .normal)
        button.layer.cornerCurve = .continuous
        button.backgroundColor = .white
        button.tintColor = .darkGray
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.3
        button.layer.shadowOffset = CGSize(width: 0, height: 2)
        button.layer.shadowRadius = 2
        return button
    }()
    
    // MARK: - LifeCycle -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.isNavigationBarHidden = true
        setupMapView()
        setupListPlacesButton()
        setupLocationService()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        setupListPlacesButtonStyle()
    }
}

private extension MapPlacesViewController {
    func setupLocationService() {
        locationService.delegate = self
        
        locationService.verifyLocationPermissions()
        
        locationService.handleAuthorizationDenied = { [weak self] in
            self?.handleAuthorizationStatusDenied()
        }
        locationService.handleAuthorizationUnknown = { [weak self] in
            self?.showTryAgainAlert(message: Constant.Alert.messageUnknownError) {
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
                equalToConstant: Constant.listPlacesButtonWidth
            ),
            listPlacesButton.heightAnchor.constraint(
                equalTo: listPlacesButton.widthAnchor
            ),
        ])
    }
    
    func setupListPlacesButtonStyle() {
        let cornerRadius = listPlacesButton.frame.size.width / 2
        listPlacesButton.layer.cornerRadius = cornerRadius
    }
    
    @objc func routeToListPlaces() {
        let listPlacesModule = ListPlacesViewController(placesList: placesList)
        navigationController?.pushViewController(listPlacesModule, animated: true)
    }
    
    func updateMap(
        location: CLLocationCoordinate2D,
        zoom: Float = Constant.defaultZoom
    ) {
        let camera = GMSCameraPosition.camera(withTarget: location, zoom: zoom)
        mapView.camera = camera
        
        fetchPlaces(location: location)
    }
    
    func fetchPlaces(location: CLLocationCoordinate2D) {
        let endpoint = Endpoint.searchNearby(
            latitude: location.latitude,
            longitude: location.longitude
        )
        
        networkService.request(
            endpoint: endpoint,
            type: NearbySearchResponse.self
        ) { [weak self] response in
            guard let self else {
                return
            }
            
            switch response {
            case .success(let data):
                self.handleSuccessRequest(data: data)
            case .failure(let error):
                self.showTryAgainAlert(message: error.localizedDescription) { [weak self] in
                    self?.locationService.verifyLocationPermissions()
                }
            }
        }
    }
    
    func handleSuccessRequest(data: NearbySearchResponse?) {
        guard let safeData = data,
              let dataResults = safeData.places else {
            return
        }

        addMarkers(for: dataResults)
        
        placesList = dataResults
    }
    
    func addMarkers(for places: [Place]) {
        DispatchQueue.main.async {
            for place in places {
                self.addMarker(for: place)
            }
        }
    }
    
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
    
    func handleAuthorizationStatusDenied() {
        let action = {
            UIApplication.openAppSettings()
        }
        
        let cancelAction = AlertButtonAction(
            title: Constant.Alert.actionTitleCancel,
            style: .cancel,
            completion: nil
        )
        let settingsAction: AlertButtonAction = AlertButtonAction(
            title: Constant.Alert.actionTitleSettings,
            style: .default,
            completion: action
        )
        
        showAlert(
            title: Constant.Alert.titleAuthorizationDenied,
            message: Constant.Alert.messageAuthorizationDenied,
            actions: [cancelAction, settingsAction]
        )
    }
    
    func showTryAgainAlert(
        title: String = Constant.Alert.defaultTryAgainAlertTitle,
        message: String,
        action: @escaping EmptyBlock
    ) {
        let cancelButton = AlertButtonAction(
            title: Constant.Alert.defaultCancelTitle,
            style: .cancel,
            completion: nil
        )
        let tryAgainButton = AlertButtonAction(
            title: Constant.Alert.defaultTryAgainActionTitle,
            style: .default,
            completion: action
        )
        
        showAlert(
            title: title,
            message: message,
            actions: [cancelButton, tryAgainButton]
        )
    }
}

extension MapPlacesViewController: LocationServiceDelegate {
    func didUpdateLocation(location: CLLocationCoordinate2D) {
        updateMap(location: location)
    }
}

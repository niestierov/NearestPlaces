//
//  MapPlacesViewController.swift
//  NearestPlaces
//
//  Created by Denys Niestierov on 09.11.2023.
//

import UIKit
import GoogleMaps

protocol MapPlacesView: AnyObject {
    func updateMap(location: CLLocationCoordinate2D)
    func update(with places: [Place])
    func showAuthorizationDeniedAlert()
    func showTryAgainAlert(
        message: String,
        action: @escaping EmptyBlock
    )
    func showRequestFailureAlert(message: String)
}

final class MapPlacesViewController: UIViewController {
    private enum Constant {
        static let defaultVerticalInset: CGFloat = 75
        static let defaultHorizontalInset: CGFloat = 10
        static let defaultZoom: Float = 8
        
        enum ListPlacesButton {
            static let shadowOpacity: Float = 0.3
            static let shadowRadius: CGFloat = 2
            static let width: CGFloat = 56
            static let image = "list.clipboard"
            static let shadowOffset = CGSize(width: 0, height: 2)
        }
        
        enum Alert {
            static let actionTitleCancel = "Cancel"
            static let actionTitleSettings = "Open Settings"
            static let titleAuthorizationDenied = "Location Services Disabled"
            static let messageAuthorizationDenied = "You should enable location services in the settings for the program to work correctly."
            static let defaultTryAgainAlertTitle = "Error"
            static let defaultTryAgainActionTitle = "Try Again"
            static let defaultCancelTitle = "Cancel"
            static let messageUnknownError = "It seems like there's been an unknown error. You can try to download the data again."
            static let defaultFailureActionTitle = "Okay"
        }
    }
    
    // MARK: - Properties -
    
    private let presenter: MapPlacesPresenter!
    
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
        presenter.performInitialSetup()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        listPlacesButton.setRoundedCornerRadius()
    }
    
    init(presenter: MapPlacesPresenter) {
        self.presenter = presenter
        
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
        presenter.navigateToPlacesList()
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
}

// MARK: - MapPlacesViewProtocol -

extension MapPlacesViewController: MapPlacesView {
    func updateMap(location: CLLocationCoordinate2D) {
        let camera = GMSCameraPosition.camera(
            withTarget: location,
            zoom: Constant.defaultZoom
        )
        
        mapView.animate(to: camera)
    }
    
    func update(with places: [Place]) {
        DispatchQueue.main.async {
            for place in places {
                self.addMarker(for: place)
            }
        }
    }
    
    func showAuthorizationDeniedAlert() {
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
            title: Constant.Alert.defaultTryAgainAlertTitle,
            message: message,
            actions: [cancelButton, tryAgainButton]
        )
    }
    
    func showRequestFailureAlert(message: String) {
        let actionButton = AlertButtonAction(
            title: Constant.Alert.defaultFailureActionTitle,
            style: .default,
            completion: nil
        )
        
        showAlert(
            title: Constant.Alert.defaultTryAgainAlertTitle,
            message: message,
            actions: [actionButton]
        )
    }
}

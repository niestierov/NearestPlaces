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
        static let navigationControllerTitle = "Map"
        static let requestPlacesManuallyImage = "arrow.clockwise.circle"
        static let distanceFilter: CLLocationDistance = 50
        static let defaultZoom: Float = 14.0
        static let nextPageDelay: DispatchTime = .now() + 2
        
        enum Alert {
            static let actionTitleCancel = "Cancel"
            static let actionTitleSettings = "Open Settings"
            static let actionTitleRequestError = "Try Again"
            static let titleAuthorizationDenied = "Location Services Disabled"
            static let messageAuthorizationDenied = "You should enable location services in the settings for the program to work correctly."
            static let messageUnknownError = "It seems like there's been an unknown error. You can try to download the data again."
            static let titleRequestError = "There is an Error"
        }
    }
    
    // MARK: - Properties -
    private let locationManager = CLLocationManager()
    private let networkService: NetworkService
    private var placesList: [PlaceInfo] = []
    private var markersList = Set<String>()
    private var nextPageEndpoint: Endpoint?
    
    // MARK: - UIComponents -
    private var mapView: GMSMapView = {
        let map = GMSMapView()
        map.settings.myLocationButton = true
        map.isMyLocationEnabled = true
        map.translatesAutoresizingMaskIntoConstraints = false
        return map
    }()
    private lazy var requestPlacesManuallyButton: UIBarButtonItem = {
        let button = UIBarButtonItem()
        button.image = UIImage(systemName: Constant.requestPlacesManuallyImage)
        button.target = self
        button.action = #selector(requestNextPage)
        return button
    }()
    
    // MARK: - LifeCycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = Constant.navigationControllerTitle
        navigationItem.leftBarButtonItem = requestPlacesManuallyButton
        
        setupMapView()
        setupLocationManager()
    }
    
    init(networkService: NetworkService) {
        self.networkService = networkService
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension MapPlacesViewController {
    
    func setupMapView() {
        view.addSubview(mapView)
        
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.topAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.distanceFilter = Constant.distanceFilter
        
        locationManager.requestWhenInUseAuthorization()
        isUserAuthorized()
    }
    
    func isUserAuthorized() {
        switch locationManager.authorizationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case.restricted, .denied:
            handleAuthorizationStatusDenied()
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
        @unknown default:
            handleFailureRequest(error: nil)
        }
    }
    
    func updateUserLocation(
        location: CLLocationCoordinate2D,
        zoom: Float = Constant.defaultZoom
    ) {
        let camera = GMSCameraPosition.camera(withTarget: location, zoom: zoom)
        mapView.camera = camera
        
        requestPlacesWithLocation(location)
    }
    
    func requestPlacesWithLocation(_ location: CLLocationCoordinate2D) {
        let endpoint = Endpoint.places(
            latitude: location.latitude,
            longitude: location.longitude
        )
        
        loadPlaces(endpoint: endpoint)
    }
    
    func loadPlaces(endpoint: Endpoint) {
        networkService.request(
            endpoint: endpoint,
            type: Place.self
        ) { [weak self] response in
            guard let self else {
                return
            }
            
            switch response {
            case .success(let data):
                self.handleSuccessRequest(data: data)
            case .failure(let error):
                self.handleFailureRequest(error: error)
            }
        }
    }
    
    func showPlaceMarkers(for place: [PlaceInfo]) {
        DispatchQueue.main.async {
            for place in self.placesList {
                if !self.markersList.contains(place.name) {
                    self.addPlaceMarker(for: place)
                }
            }
        }
    }
    
    func addPlaceMarker(for place: PlaceInfo) {
        let latitude = place.geometry.location.latitude
        let longitude = place.geometry.location.longitude
        let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        
        let marker = GMSMarker(position: location)
        marker.title = place.name
        marker.snippet = place.vicinity
        marker.map = mapView
        
        markersList.insert(place.name)
    }
    
    @objc func requestNextPage() {
        guard let endpoint = nextPageEndpoint else {
            return
        }
        
        self.loadPlaces(endpoint: endpoint)
    }
    
    func handleSuccessRequest(data: Place?) {
        guard let safeData = data,
              let dataResults = safeData.results else {
            return
        }
        
        placesList.append(contentsOf: dataResults)
        
        showPlaceMarkers(for: placesList)

        if let safeToken = safeData.nextPageToken {
            nextPageEndpoint = Endpoint.nextPage(token: safeToken)
            
            //: The next request is valid after a few sec delay
            DispatchQueue.global(qos: .background).asyncAfter(deadline: Constant.nextPageDelay) {
                self.requestNextPage()
            }
        }
    }
    
    func handleFailureRequest(error: Error?) {
        let action = {
            self.locationManager.startUpdatingLocation()
        }
        
        let tryAgainAction: AlertButtonAction = (Constant.Alert.actionTitleRequestError, action)
        
        showAlert(
            title: Constant.Alert.titleRequestError,
            message: error?.localizedDescription ?? Constant.Alert.messageUnknownError,
            actions: [tryAgainAction]
        )
    }
    
    func handleAuthorizationStatusDenied() {
        let action = {
            if let appSettingsURL = URL(string: UIApplication.openSettingsURLString), UIApplication.shared.canOpenURL(appSettingsURL) {
                UIApplication.shared.open(appSettingsURL, options: [:])
            }
        }
        
        let cancelAction: AlertButtonAction = (Constant.Alert.actionTitleCancel, nil)
        let settingsAction: AlertButtonAction = (Constant.Alert.actionTitleSettings, action)
        
        showAlert(
            title: Constant.Alert.titleAuthorizationDenied,
            message: Constant.Alert.messageAuthorizationDenied,
            actions: [cancelAction, settingsAction]
        )
    }
}

extension MapPlacesViewController: CLLocationManagerDelegate {
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        isUserAuthorized()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = manager.location?.coordinate else {
            return
        }
        
        updateUserLocation(location: location)
    }
}

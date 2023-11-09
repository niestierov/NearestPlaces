//
//  MapPlacesViewController.swift
//  NearestPlaces
//
//  Created by Denys Niestierov on 09.11.2023.
//

import UIKit
import GoogleMaps
import GooglePlaces

final class MapPlacesViewController: UIViewController {
    
    private struct Constant {
        static let distanceFilter: CLLocationDistance = 20
        static let defaultZoom: Float = 14.0
    }
    
    // MARK: - Properties -
    private let locationManager = CLLocationManager()
    private let placesClient = GMSPlacesClient.shared()
    private let networkService: NetworkService
    private var places: [PlaceInfo]?
    
    // MARK: - UIComponents -
    private var mapView: GMSMapView = {
        let map = GMSMapView()
        map.settings.myLocationButton = true
        map.isMyLocationEnabled = true
        map.translatesAutoresizingMaskIntoConstraints = false
        return map
    }()
    
    // MARK: - LifeCycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
            break
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
    
    func showMarker(for place: PlaceInfo) {
        let latitude = place.geometry.location.latitude
        let longitude = place.geometry.location.longitude
        
        let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let marker = GMSMarker(position: location)
        
        marker.title = place.name
        marker.snippet = place.vicinity
        marker.map = mapView
    }
    
    func handleAuthorizationStatusDenied() {
        let action = {
            if let appSettingsURL = URL(string: UIApplication.openSettingsURLString), UIApplication.shared.canOpenURL(appSettingsURL) {
                UIApplication.shared.open(appSettingsURL, options: [:])
            }
        }
        
        let cancelAction: AlertButtonAction = ("Cancel", nil)
        let settingsAction: AlertButtonAction = ("Okay", action)
        
        showAlert(
            title: AppConstant.LocationAuthorizationStatus.Denied.title,
            message: AppConstant.LocationAuthorizationStatus.Denied.message,
            actions: [cancelAction, settingsAction]
        )
    }
    
    func handleSuccessRequest(data: Place?) {
        guard let results = data?.results else {
            return
        }
        
        fetchPlacesResult(with: results)
        
        if let nextPageToken = data?.nextPageToken {
            let endpoint = Endpoint.nextPage(token: nextPageToken)
            
            loadPlaces(endpoint: endpoint)
        }
    }
    
    func fetchPlacesResult(with places: [PlaceInfo]?) {
        DispatchQueue.main.async {
            self.places = places?.compactMap {
                PlaceInfo.fromPlaceInfo($0, type: PlaceInfo.self)
            }
            
            guard let safePlaces = self.places else {
                return
            }
                
            for place in safePlaces {
                self.showMarker(for: place)
            }
        }
        
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
        ) { [unowned self] response in
            switch response {
            case .success(let data):
                self.handleSuccessRequest(data: data)
            case .failure(let error):
                print(error)
            }
        }
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

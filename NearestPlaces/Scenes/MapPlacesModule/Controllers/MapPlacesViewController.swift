//
//  MapPlacesViewController.swift
//  NearestPlaces
//
//  Created by Denys Niestierov on 09.11.2023.
//

import UIKit
import GoogleMaps
import GooglePlaces

class MapPlacesViewController: UIViewController {

    // MARK: - Properties -
    private var locationManager = CLLocationManager()
    private var placesClient = GMSPlacesClient.shared()
    
    // MARK: - UIComponents -
    private var mapView: GMSMapView = {
        let view = GMSMapView()
        view.settings.myLocationButton = true
        view.isMyLocationEnabled = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - LifeCycle -
    override func viewDidLoad() {
        super.viewDidLoad()

        setupMapView()
        setupLocationManager()
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
        
        let distanceFilter: CLLocationDistance = 20
        locationManager.distanceFilter = distanceFilter
        
        locationManager.requestWhenInUseAuthorization()
    }
    
    func isUserAuthorized() {
        switch locationManager.authorizationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case.restricted, .denied:
            print("Denied.")
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
        @unknown default:
            break
        }
    }
    
    func updateMapPosition(location: CLLocationCoordinate2D, zoom: Float = 15.0) {
        let camera = GMSCameraPosition.camera(withTarget: location, zoom: zoom)
        mapView.camera = camera
        showMarker(location: location)
        showMarker(location: location)
        showMarker(location: location)
    }
    
    func showMarker(location: CLLocationCoordinate2D){
        let marker = GMSMarker()
        marker.position = location
        
        marker.title = "Test"
        marker.snippet = "Test2"
        marker.map = mapView
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
        
        updateMapPosition(location: location)
    }
}

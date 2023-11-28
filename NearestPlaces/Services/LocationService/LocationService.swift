//
//  LocationService.swift
//  NearestPlaces
//
//  Created by Denys Niestierov on 13.11.2023.
//

import UIKit
import CoreLocation

protocol LocationServiceDelegate: AnyObject {
    func didUpdateLocation(location: CLLocationCoordinate2D)
}

final class LocationService: NSObject {
    private enum Constant {
        static let distanceFilter: CLLocationDistance = 50
    }
    
    // MARK: - Properties -
    
    private let locationManager = CLLocationManager()
    weak var delegate: LocationServiceDelegate?
    var handleAuthorizationUnknown: (() -> Void)?
    var handleAuthorizationDenied: (() -> Void)?
    
    // MARK: - LifeCycle -
    
    override init() {
        super.init()
        
        setupLocationManager()
    }
    
    // MARK: - Iternal -
    
    func verifyLocationPermissions() {
        switch locationManager.authorizationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            
        case .restricted, .denied:
            handleAuthorizationDenied?()
            
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
            
        @unknown default:
            handleAuthorizationUnknown?()
        }
    }
}

private extension LocationService {
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.distanceFilter = Constant.distanceFilter
    }
}

extension LocationService: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        verifyLocationPermissions()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = manager.location?.coordinate else {
            return
        }
        
        delegate?.didUpdateLocation(location: location)
        
        locationManager.stopUpdatingLocation()
    }
}

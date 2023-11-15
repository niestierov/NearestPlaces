//
//  LocationService.swift
//  NearestPlaces
//
//  Created by Denys Niestierov on 13.11.2023.
//

import CoreLocation
import UIKit

protocol LocationServiceDelegate: AnyObject {
    func locationService(_ locationService: LocationService, didUpdateLocation location: CLLocationCoordinate2D)
}

final class LocationService: NSObject {
    private enum Constant {
        static let distanceFilter: CLLocationDistance = 50
        
        enum Alert {
            static let actionTitleCancel = "Cancel"
            static let actionTitleSettings = "Open Settings"
            static let titleAuthorizationDenied = "Location Services Disabled"
            static let messageAuthorizationDenied = "You should enable location services in the settings for the program to work correctly."
            static let messageUnknownError = "It seems like there's been an unknown error. You can try to download the data again."
        }
    }
    
    // MARK: - Properties -
    
    private let locationManager = CLLocationManager()
    weak var delegate: LocationServiceDelegate?
    var showTryAgainAlert: ((String?, String, @escaping EmptyBlock) -> Void)?
    var showAuthorizationDeniedAlert: ((Alert) -> Void)?
    
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
            handleAuthorizationStatusDenied()
            
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
            
        @unknown default:
            showTryAgainAlert?(
                nil,
                Constant.Alert.messageUnknownError,
                verifyLocationPermissions
            )
        }
    }
}

private extension LocationService {
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.distanceFilter = Constant.distanceFilter
    }
    
    func handleAuthorizationStatusDenied() {
        let action = {
            UIApplication.openAppSettings()
        }
        
        let cancelAction: AlertButtonAction = (Constant.Alert.actionTitleCancel, .cancel, nil)
        let settingsAction: AlertButtonAction = (Constant.Alert.actionTitleSettings, .default, action)
        let alert = (
            Constant.Alert.titleAuthorizationDenied,
            Constant.Alert.messageAuthorizationDenied,
            [cancelAction, settingsAction]
        )
        
        showAuthorizationDeniedAlert?(alert)
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
        
        delegate?.locationService(self, didUpdateLocation: location)
    }
}

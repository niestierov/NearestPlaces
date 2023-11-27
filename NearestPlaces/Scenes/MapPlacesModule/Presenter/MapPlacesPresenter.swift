//
//  MapPlacesPresenter.swift
//  NearestPlaces
//
//  Created by Denys Niestierov on 24.11.2023.
//

import UIKit
import CoreLocation

protocol MapPlacesPresenter {
    var placesList: [Place] { get }
    
    func fetchPlaces(location: CLLocationCoordinate2D)
    func handleAuthorizationStatusDenied()
    func createTryAgainAlert(
        message: String,
        action: @escaping EmptyBlock
    )
    func placesListButtonTapped()
    func setupLocationService()
}

final class MapPlacesPresenterImpl: MapPlacesPresenter {
    private enum Constant {
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
    
    private weak var view: MapPlacesView?
    private let router: Router
    private let networkService: NetworkService
    private let locationService: LocationService
    private(set) var placesList: [Place] = []
    
    // MARK: - Life Cycle -
    
    required init(
        router: Router,
        networkService: NetworkService,
        locationService: LocationService
    ) {
        self.router = router
        self.networkService = networkService
        self.locationService = locationService
    }
    
    // MARK: - Internal -
    
    func inject(view: MapPlacesView) {
        self.view = view
    }
    
    func setupLocationService() {
        view?.setLocationServiceDelegate(for: locationService)
        
        locationService.verifyLocationPermissions()
        
        locationService.handleAuthorizationDenied = { [weak self] in
            self?.handleAuthorizationStatusDenied()
        }
        locationService.handleAuthorizationUnknown = { [weak self] in
            self?.createTryAgainAlert(message: Constant.Alert.messageUnknownError) {
                self?.locationService.verifyLocationPermissions()
            }
        }
    }
    
    func placesListButtonTapped() {
        router.showPlacesListModule(placesList: placesList)
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
        
        view?.showAlert(
            title: Constant.Alert.titleAuthorizationDenied,
            message: Constant.Alert.messageAuthorizationDenied,
            actions: [cancelAction, settingsAction]
        )
    }
    
    func createTryAgainAlert(
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
        
        view?.showAlert(
            title: Constant.Alert.defaultTryAgainAlertTitle,
            message: message,
            actions: [cancelButton, tryAgainButton]
        )
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
                self.createTryAgainAlert(message: error.localizedDescription) { [weak self] in
                    self?.locationService.verifyLocationPermissions()
                }
            }
        }
    }
}

// MARK: - Private -

private extension MapPlacesPresenterImpl {
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
                self.view?.addMarker(for: place)
            }
        }
    }
}

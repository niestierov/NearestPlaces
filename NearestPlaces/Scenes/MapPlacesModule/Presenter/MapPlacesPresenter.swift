//
//  MapPlacesPresenter.swift
//  NearestPlaces
//
//  Created by Denys Niestierov on 24.11.2023.
//

import UIKit
import CoreLocation

protocol MapPlacesPresenter {
    func performInitialSetup()
    func navigateToPlacesList()
}

final class DefaultMapPlacesPresenter: MapPlacesPresenter {
    private enum Constant {
        static let alertUnknownErrorMessage = "It seems like there's been an unknown error. You can try to download the data again."
    }
    
    // MARK: - Properties -
    
    private weak var view: MapPlacesView?
    private let router: Router
    private let networkService: NetworkService
    private let locationService: LocationService
    private var placesList: [Place] = []
    
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
    
    func setView(_ view: MapPlacesView) {
        self.view = view
    }
    
    func performInitialSetup() {
        setupLocationService()
    }
    
    func navigateToPlacesList() {
        router.showPlacesListModule(with: placesList)
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
                handleSuccessRequest(data: data)
            case .failure(let error):
                self.view?.showRequestFailureAlert(message: error.localizedDescription)
            }
        }
    }
}

// MARK: - Private -

private extension DefaultMapPlacesPresenter {
    func setupLocationService() {
        locationService.delegate = self
        
        locationService.verifyLocationPermissions()
        
        locationService.handleAuthorizationDenied = { [weak self] in
            self?.view?.showAuthorizationDeniedAlert()
        }
        locationService.handleAuthorizationUnknown = { [weak self] in
            self?.view?.showTryAgainAlert(message: Constant.alertUnknownErrorMessage) {
                self?.locationService.verifyLocationPermissions()
            }
        }
    }
    
    func handleSuccessRequest(data: NearbySearchResponse?) {
        let places = data?.places ?? []
        placesList = places
        
        view?.update(with: places)
    }
}

// MARK: - LocationServiceDelegate -

extension DefaultMapPlacesPresenter: LocationServiceDelegate {
    func didUpdateLocation(location: CLLocationCoordinate2D) {
        self.view?.updateMap(location: location)
        
        fetchPlaces(location: location)
    }
}

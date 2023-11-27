//
//  Router.swift
//  NearestPlaces
//
//  Created by Denys Niestierov on 27.11.2023.
//

import UIKit

protocol Router: AnyObject {
    func showMapPlacesModule()
    func showPlacesListModule(placesList: [Place])
}

class RouterImpl: Router {
    
    // MARK: - Properties -
    
    private let navigationController: UINavigationController
    private let networkService: NetworkService
    private let locationService: LocationService
    
    // MARK: - Life Cycle -
    required init(
        navigationController: UINavigationController,
        networkService: NetworkService,
        locationService: LocationService
    ) {
        self.navigationController = navigationController
        self.networkService = networkService
        self.locationService = locationService
    }
    
    // MARK: - Internal -
    
    func showMapPlacesModule() {
        let presenter = MapPlacesPresenterImpl(
            router: self,
            networkService: networkService,
            locationService: locationService
        )
        let viewController = MapPlacesViewController(presenter: presenter)
        presenter.inject(view: viewController)
        
        navigationController.setViewControllers([viewController], animated: true)
    }
    
    func showPlacesListModule(placesList: [Place]) {
        let presenter = PlacesListPresenterImpl(router: self, placesList: placesList)
        let viewController = PlacesListViewController(presenter: presenter)
        presenter.inject(view: viewController)
        
        navigationController.pushViewController(viewController, animated: true)
    }
}

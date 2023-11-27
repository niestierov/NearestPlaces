//
//  Router.swift
//  NearestPlaces
//
//  Created by Denys Niestierov on 27.11.2023.
//

import UIKit

protocol Router: AnyObject {
    func showMapPlacesModule()
    func showPlacesListModule(with placesList: [Place])
}

final class MainRouter: Router {
    
    // MARK: - Properties -
    
    private let navigationController: UINavigationController
    
    // MARK: - Life Cycle -
    
    required init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    // MARK: - Internal -
    
    func showMapPlacesModule() {
        let networkService = NetworkService()
        let locationService = LocationService()
        
        let presenter = MapPlacesPresenterImpl(
            router: self,
            networkService: networkService,
            locationService: locationService
        )
        let viewController = MapPlacesViewController(presenter: presenter)
        presenter.inject(view: viewController)
        
        navigationController.setViewControllers([viewController], animated: true)
    }
    
    func showPlacesListModule(with placesList: [Place]) {
        let presenter = PlacesListPresenterImpl(router: self, placesList: placesList)
        let viewController = PlacesListViewController(presenter: presenter)
        presenter.inject(view: viewController)
        
        navigationController.pushViewController(viewController, animated: true)
    }
}

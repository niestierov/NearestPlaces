//
//  Router.swift
//  NearestPlaces
//
//  Created by Denys Niestierov on 09.11.2023.
//

import UIKit

protocol RouterProtocol {
    func showMapPlacesModule()
}

final class Router {
    
    // MARK: - Properties -
    private var navigationController: UINavigationController?
    private var networkService: NetworkService
    
    // MARK: - LifeCycle -
    init(
        navigationController: UINavigationController,
        networkService: NetworkService
    ) {
        self.navigationController = navigationController
        self.networkService = networkService
    }
    
    // MARK: - Iternal -
    func showMapPlacesModule() {
        let mapPlacesModule = MapPlacesViewController(router: self, networkService: networkService)
        navigationController?.setViewControllers([mapPlacesModule], animated: true)
    }
}

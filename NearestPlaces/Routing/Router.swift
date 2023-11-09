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
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    // MARK: - Iternal -
    func showMapPlacesModule() {
        let mapPlacesModule = MapPlacesViewController()
        navigationController?.setViewControllers([mapPlacesModule], animated: true)
    }
}

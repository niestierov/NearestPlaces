//
//  SceneDelegate.swift
//  NearestPlaces
//
//  Created by Denys Niestierov on 06.11.2023.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else {
            return
        }

        startRootScreen(for: windowScene)
    }

    private func startRootScreen(for windowScene: UIWindowScene) {
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
        
        
        let navigationController = UINavigationController()
        let networkService = NetworkService()
        let locationService = LocationService()
        
        let router = RouterImpl(
            navigationController: navigationController,
            networkService: networkService,
            locationService: locationService
        )
        
        router.showMapPlacesModule()
        
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
}


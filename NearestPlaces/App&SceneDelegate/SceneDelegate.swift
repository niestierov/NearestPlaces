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

    func startRootScreen(for windowScene: UIWindowScene) {
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
        
        let navigationController: UINavigationController = {
            let controller = UINavigationController()
            controller.setNavigationControllerAppearance()
            return controller
        }()
        let networkService = NetworkService()
        let router = Router(
            navigationController: navigationController,
            networkService: networkService
        )
        
        router.showMapPlacesModule()
        
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
    
}


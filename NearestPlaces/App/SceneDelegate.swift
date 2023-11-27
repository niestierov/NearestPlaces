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
        
        let mapPlacesPresenter = MapPlacesPresenter()
        let mapPlacesViewController = MapPlacesViewController(presenter: mapPlacesPresenter)
        
        mapPlacesPresenter.inject(view: mapPlacesViewController)
        
        let navigationController = UINavigationController(rootViewController: mapPlacesViewController)
        
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
}


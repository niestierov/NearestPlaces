//
//  AppDelegate.swift
//  NearestPlaces
//
//  Created by Denys Niestierov on 06.11.2023.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        GoogleServicesConfigurator.configure()
        
        return true
    }
}



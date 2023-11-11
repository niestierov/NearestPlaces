//
//  AppDelegate.swift
//  NearestPlaces
//
//  Created by Denys Niestierov on 06.11.2023.
//

import UIKit
import GoogleMaps

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        if let apiKey = Bundle.main.object(forInfoDictionaryKey: AppConstant.apiKeyGoogle) as? String {
            GMSServices.provideAPIKey(apiKey)
        }
        
        return true
    }
}


//
//  GoogleServicesConfigurator.swift
//  NearestPlaces
//
//  Created by Denys Niestierov on 13.11.2023.
//

import GoogleMaps

final class GoogleServicesConfigurator {
    private static let apiKeyGoogle = "API_KEY_GOOGLE"
    
    static func configure() {
        if let apiKey = Bundle.main.object(forInfoDictionaryKey: apiKeyGoogle) as? String {
            GMSServices.provideAPIKey(apiKey)
        }
    }
    
    static func getKey() -> String {
        let key = Bundle.main.object(
            forInfoDictionaryKey: apiKeyGoogle
        ) as? String ?? ""
        
        return key
    }
}

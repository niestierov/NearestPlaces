//
//  Constants.swift
//  NearestPlaces
//
//  Created by Denys Niestierov on 09.11.2023.
//

import Foundation

struct Constant {
    
    static let apiKeyGoogle = "API_KEY_GOOGLE"
    
    struct LocationAuthorizationStatus {
        
        struct Denied {
            static let title = "Location Services Disabled"
            static let message = "You should enable location services in the settings for the program to work correctly."
        }
    }
}

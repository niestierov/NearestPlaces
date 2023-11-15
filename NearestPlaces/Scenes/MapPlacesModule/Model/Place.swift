//
//  Place.swift
//  NearestPlaces
//
//  Created by Denys Niestierov on 09.11.2023.
//

import Foundation

struct NearbySearchResponse: Decodable {
    let places: [Place]?
}

struct Place: Decodable {
    let formattedAddress: String?
    let iconMaskBaseUri: String?
    let rating: Double?
    let location: PlaceLocation
    let displayName: DisplayName?
    
    struct PlaceLocation: Decodable {
        let latitude: Double
        let longitude: Double
    }
    
    struct DisplayName: Decodable {
        let text: String?
    }
}


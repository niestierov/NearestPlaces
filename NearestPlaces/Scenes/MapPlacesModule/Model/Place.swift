//
//  Place.swift
//  NearestPlaces
//
//  Created by Denys Niestierov on 09.11.2023.
//

import Foundation

struct Place: Codable {
    let nextPageToken: String?
    let results: [PlaceInfo]?
    
    enum CodingKeys: String, CodingKey {
        case nextPageToken = "next_page_token"
        case results
    }
}

struct PlaceInfo: Codable {
    let name: String
    let icon: URL
    let rating: Float
    let vicinity: String
    let geometry: PlaceGeometry
    
    struct PlaceGeometry: Codable {
        let location: PlaceLocation
        
        struct PlaceLocation: Codable {
            let latitude: Double
            let longitude: Double
            
            enum CodingKeys: String, CodingKey {
                case latitude = "lat"
                case longitude = "lng"
            }
        }
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        name = try container.decodeIfPresent(String.self, forKey: .name) ?? ""
        icon = try container.decode(URL.self, forKey: .icon)
        rating = try container.decodeIfPresent(Float.self, forKey: .rating) ?? 0.0
        vicinity = try container.decodeIfPresent(String.self, forKey: .vicinity) ?? ""
        geometry = try container.decode(PlaceGeometry.self, forKey: .geometry)
    }
}

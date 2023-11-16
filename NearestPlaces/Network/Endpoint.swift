//
//  Endpoint.swift
//  NearestPlaces
//
//  Created by Denys Niestierov on 09.11.2023.
//

import Alamofire
import Foundation

fileprivate enum EndpointConstant {
    static let urlScheme = "https"
    static let urlHost = "places.googleapis.com"
    static let urlPath = "/v1/places:searchNearby"
    
    static let urlStringError = "Error constructing URL."
}

fileprivate enum APIConstant {
    enum Parameters {
        static let kTypes = "includedTypes"
        static let kLocationRestriction = "locationRestriction"
        static let kCircle = "circle"
        static let kCenter = "center"
        static let kRadius = "radius"
        static let kLongitude = "longitude"
        static let kLatitude = "latitude"
        
        static let types = ["restaurant", "cafe"]
        static let radius = 5000
    }
    
    enum Headers {
        static let kApiKey = "X-Goog-Api-Key"
        static let kFieldMask = "X-Goog-FieldMask"
        static let kContentType = "Content-Type"
        
        static let contentType = "application/json"
        static let formattedAddress = "places.formattedAddress"
        static let name = "places.displayName"
        static let iconMask = "places.iconMaskBaseUri"
        static let location = "places.location"
        static let rating = "places.rating"
        static let defaultFieldMask =
        "\(APIConstant.Headers.name),\(APIConstant.Headers.formattedAddress),\(APIConstant.Headers.location),\(APIConstant.Headers.iconMask),\(APIConstant.Headers.rating)"
        static let apiKey: String = GoogleServicesConfigurator.getKey()
    }
}

enum Endpoint {
    case searchNearby(
        latitude: Double,
        longitude: Double,
        radius: Int = APIConstant.Parameters.radius,
        type: [String] = APIConstant.Parameters.types
    )
    
    var method: HTTPMethod {
        switch self {
        case .searchNearby:
            return .post
        }
    }
    
    var encoding: ParameterEncoding {
        switch self {
        case .searchNearby:
            return JSONEncoding.default
        }
    }
    
    var scheme: String {
        switch self {
        case .searchNearby:
            return EndpointConstant.urlScheme
        }
    }
    
    var host: String {
        switch self {
        case .searchNearby:
            return EndpointConstant.urlHost
        }
    }
    
    var path: String {
        switch self {
        case .searchNearby:
            return EndpointConstant.urlPath
        }
    }
    
    var headers: HTTPHeaders? {
        switch self {
        case .searchNearby:
            return [
                APIConstant.Headers.kContentType: APIConstant.Headers.contentType,
                APIConstant.Headers.kApiKey: APIConstant.Headers.apiKey,
                APIConstant.Headers.kFieldMask: APIConstant.Headers.defaultFieldMask
            ]
        }
    }
    
    var parameters: [String: Any]? {
        switch self {
        case .searchNearby(let latitude, let longitude, let radius, let types):
            let locationRestriction: [String: Any] = [
                APIConstant.Parameters.kCircle: [
                    APIConstant.Parameters.kCenter: [
                        APIConstant.Parameters.kLatitude: latitude,
                        APIConstant.Parameters.kLongitude: longitude
                    ],
                    APIConstant.Parameters.kRadius: radius
                ] as [String : Any]
            ]
            
            return [
                APIConstant.Parameters.kTypes: types,
                APIConstant.Parameters.kLocationRestriction: locationRestriction
            ]
        }
    }
    
    func fullURLString() -> String? {
        var urlBuilder = URLComponents()
        urlBuilder.scheme = scheme
        urlBuilder.host = host
        urlBuilder.path = path
        
        guard let urlString = urlBuilder.string else {
            return nil
        }
        
        return urlString
    }
}

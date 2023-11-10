//
//  Endpoint.swift
//  NearestPlaces
//
//  Created by Denys Niestierov on 09.11.2023.
//

import Alamofire
import Foundation

private struct EndpointConstant {
    static let urlScheme = "https"
    static let urlHost = "maps.googleapis.com"
    static let urlPath = "/maps/api/place/nearbysearch/json"
    
    static let urlStringError = "Error constructing URL."
}

struct APIConstant {
    static let kLocation = "location"
    static let kRadius = "radius"
    static let kType = "types"
    static let kApiKey = "key"
    static let kNextPageToken = "pagetoken"
    
    static let apiKey = Bundle.main.object(forInfoDictionaryKey: AppConstant.apiKeyGoogle) as! String
    static let defaultType = "restaurant|cafe"
    static let defaultRadius = 5000
}

enum Endpoint {
    case nextPage(token: String)
    case places(
        latitude: Double,
        longitude: Double,
        radius: Int = APIConstant.defaultRadius,
        type: String = APIConstant.defaultType
    )
    
    var method: HTTPMethod {
        return .get
    }
    
    var encoding: ParameterEncoding {
        return URLEncoding.default
    }
    
    var scheme: String {
        switch self {
        case .places, .nextPage:
            return EndpointConstant.urlScheme
        }
    }
    
    var host: String {
        switch self {
        case .places, .nextPage:
            return EndpointConstant.urlHost
        }
    }
    
    var path: String {
        switch self {
        case .places, .nextPage:
            return EndpointConstant.urlPath
        }
    }
    
    var parameters: [String: Any]? {
        switch self {
        case .places(let latitude, let longitude, let radius, let type):
            let location = "\(latitude),\(longitude)"
            return [
                APIConstant.kLocation: location,
                APIConstant.kRadius: radius,
                APIConstant.kType: type,
                APIConstant.kApiKey: APIConstant.apiKey
            ]
        case .nextPage(let token):
            return [
                APIConstant.kApiKey: APIConstant.apiKey,
                APIConstant.kNextPageToken: token,
            ]
        }
    }
    
    func fullURLString() -> String? {
        var urlBuilder = URLComponents()
        urlBuilder.scheme = scheme
        urlBuilder.host = host
        urlBuilder.path = path
        urlBuilder.queryItems = parameters?.map {
            URLQueryItem(name: $0.key, value: "\($0.value)")
        }
        
        guard let urlString = urlBuilder.string else {
            return nil
        }

        return urlString
    }
}

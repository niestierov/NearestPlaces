//
//  Decodable+Extension.swift
//  NearestPlaces
//
//  Created by Denys Niestierov on 09.11.2023.
//

import Foundation

extension Decodable {
    static func fromPlaceInfo<T: Decodable>(_ object: PlaceInfo, type: T.Type) -> T? {
        do {
            let data = try JSONEncoder.default.encode(object)
            return try JSONDecoder.default.decode(T.self, from: data)
        } catch {
           return nil
        }
    }
}

extension JSONDecoder {
    static var `default`: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }
}

extension JSONEncoder {
    static var `default` = JSONEncoder()
}


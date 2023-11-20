//
//  StringIdentifiable+Extension.swift
//  NearestPlaces
//
//  Created by Denys Niestierov on 17.11.2023.
//

import Foundation

protocol StringIdentifiable: AnyObject { }

extension StringIdentifiable {
    static var identifier: String {
        return String(describing: self)
    }
}

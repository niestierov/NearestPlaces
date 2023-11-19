//
//  Reusable+Extension.swift
//  NearestPlaces
//
//  Created by Denys Niestierov on 17.11.2023.
//

import Foundation

protocol Reusable: AnyObject { }

extension Reusable {
    static var identifier: String {
        return String(describing: self)
    }
}

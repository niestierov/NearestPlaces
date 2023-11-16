//
//  Constants.swift
//  NearestPlaces
//
//  Created by Denys Niestierov on 09.11.2023.
//

import UIKit

typealias EmptyBlock = () -> Void

struct AlertButtonAction {
    let title: String
    let style: UIAlertAction.Style
    let completion: EmptyBlock?
}

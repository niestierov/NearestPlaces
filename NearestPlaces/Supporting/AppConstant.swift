//
//  Constants.swift
//  NearestPlaces
//
//  Created by Denys Niestierov on 09.11.2023.
//

import UIKit

typealias EmptyBlock = () -> Void
typealias AlertButtonAction = (
    title: String,
    style: UIAlertAction.Style,
    completion: EmptyBlock?
)
typealias Alert = (
    title: String,
    message: String,
    actions: [AlertButtonAction]
)

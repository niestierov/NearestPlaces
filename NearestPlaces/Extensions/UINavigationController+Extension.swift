//
//  UINavigationController+Extension.swift
//  NearestPlaces
//
//  Created by Denys Niestierov on 10.11.2023.
//

import UIKit

extension UINavigationController {
    func setNavigationControllerAppearance(
        opacity: CGFloat,
        backgroundColor: UIColor,
        titleColor: UIColor,
        titleFont: UIFont,
        isTranslucent: Bool = true
    ) {
        navigationBar.isTranslucent = isTranslucent
        
        navigationBar.backgroundColor = backgroundColor
        navigationBar.barTintColor = backgroundColor
        
        navigationBar.titleTextAttributes = [
            .foregroundColor: titleColor,
            .font: titleFont
        ]
    }
}

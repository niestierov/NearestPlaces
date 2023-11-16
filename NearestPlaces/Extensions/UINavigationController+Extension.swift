//
//  UINavigationController+Extension.swift
//  NearestPlaces
//
//  Created by Denys Niestierov on 10.11.2023.
//

import UIKit

extension UINavigationController {
    private enum Constant {
        static let opacity: CGFloat = 0.9
        static let whiteWithAlphaComponent = UIColor.white.withAlphaComponent(opacity)
        static let boldFontSize = UIFont.boldSystemFont(ofSize: 20)
        static let defaultTitleColor = UIColor.black
    }
    
    func setupNavigationBar(
        opacity: CGFloat = Constant.opacity,
        backgroundColor: UIColor = Constant.whiteWithAlphaComponent,
        titleColor: UIColor = Constant.defaultTitleColor,
        titleFont: UIFont = Constant.boldFontSize,
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

//
//  UINavigationController+Extension.swift
//  NearestPlaces
//
//  Created by Denys Niestierov on 10.11.2023.
//

import UIKit

extension UINavigationController {
    
    private enum Constant {
        
        enum Style {
            static let opacity: CGFloat = 0.9
            static let whiteWithAlphaComponent = UIColor.white.withAlphaComponent(opacity)
            static let boldFontSize: CGFloat = 20
        }
    }
    
    func setNavigationControllerAppearance() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = Constant.Style.whiteWithAlphaComponent

        let textAttributes: [NSAttributedString.Key : Any] = [
            .foregroundColor: UIColor.black,
            .font: UIFont.boldSystemFont(ofSize: Constant.Style.boldFontSize)
        ]
        appearance.titleTextAttributes = textAttributes
        

        navigationBar.standardAppearance = appearance
        navigationBar.compactAppearance = appearance
        navigationBar.scrollEdgeAppearance = appearance
        navigationBar.isTranslucent = true
    }
}

//
//  UIView+Extension.swift
//  NearestPlaces
//
//  Created by Denys Niestierov on 20.11.2023.
//

import UIKit

extension UIView {
    var cornerRadius: CGFloat {
        get {
            return self.layer.cornerRadius
        }
        set {
            self.layer.cornerRadius = newValue
        }
    }
    
    func setRoundedCornerRadius(
        cornerCurve: CALayerCornerCurve = .continuous
    ) {
        self.layer.cornerCurve = cornerCurve
        
        let roundedRadius = self.frame.width / 2
        self.cornerRadius = roundedRadius
    }
    
    func applyShadow(
        shadowColor: CGColor = UIColor.black.cgColor,
        shadowOpacity: Float = .zero,
        shadowOffset: CGSize = .zero,
        shadowRadius: CGFloat = .zero
    ) {
        self.layer.shadowColor = shadowColor
        self.layer.shadowOpacity = shadowOpacity
        self.layer.shadowOffset = shadowOffset
        self.layer.shadowRadius = shadowRadius
    }
}

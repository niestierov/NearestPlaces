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
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
    
    func setRoundedCornerRadius(
        cornerCurve: CALayerCornerCurve = .continuous
    ) {
        layer.cornerCurve = cornerCurve
        
        let roundedRadius = self.frame.width / 2
        cornerRadius = roundedRadius
    }
    
    func applyShadow(
        shadowColor: CGColor = UIColor.black.cgColor,
        shadowOpacity: Float = .zero,
        shadowOffset: CGSize = .zero,
        shadowRadius: CGFloat = .zero
    ) {
        layer.shadowColor = shadowColor
        layer.shadowOpacity = shadowOpacity
        layer.shadowOffset = shadowOffset
        layer.shadowRadius = shadowRadius
    }
}

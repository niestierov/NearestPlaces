//
//  UIView+Extension.swift
//  NearestPlaces
//
//  Created by Denys Niestierov on 20.11.2023.
//

import UIKit

extension UIView {
    func configure(
        backgroundColor: UIColor = .white,
        tintColor: UIColor = .white,
        shadowColor: CGColor = UIColor.black.cgColor,
        shadowOpacity: Float = .zero,
        shadowOffset: CGSize = .zero,
        shadowRadius: CGFloat = .zero
    ) {
        self.backgroundColor = backgroundColor
        self.tintColor = tintColor
        self.layer.shadowColor = shadowColor
        self.layer.shadowOpacity = shadowOpacity
        self.layer.shadowOffset = shadowOffset
        self.layer.shadowRadius = shadowRadius
    }
    
    func setCornerRadius(
        cornerRadius: CGFloat = .zero,
        roundedCornerRadius: Bool = false,
        cornerCurve: CALayerCornerCurve = .continuous
    ) {
        self.layer.cornerCurve = cornerCurve
        
        let roundedRadius = self.frame.width/2
        self.layer.cornerRadius = roundedCornerRadius ? roundedRadius : cornerRadius
    }
}

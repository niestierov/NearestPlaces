//
//  UIImageView+Extension.swift
//  NearestPlaces
//
//  Created by Denys Niestierov on 20.11.2023.
//

import UIKit

extension UIImageView {
    func setImage(with url: URL) {
        ImageService.shared.setImage(with: url, for: self)
    }

    func setImage(with urlString: String, type: String, placeholder: UIImage? = nil) {
        ImageService.shared.setImage(with: urlString, type: type, for: self, placeholder: placeholder)
    }
}

//
//  UIImageView+Extension.swift
//  NearestPlaces
//
//  Created by Denys Niestierov on 20.11.2023.
//

import UIKit

extension UIImageView {
    func setImage(with url: URL, placeholder: UIImage? = nil) {
        ImageService.shared.setImage(with: url, for: self, placeholder: placeholder)
    }

    func setImage(with urlString: String, placeholder: UIImage? = nil) {
        ImageService.shared.setImage(string: urlString, for: self, placeholder: placeholder)
    }
}

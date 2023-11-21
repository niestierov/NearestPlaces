//
//  ImageService.swift
//  NearestPlaces
//
//  Created by Denys Niestierov on 20.11.2023.
//

import Foundation
import Kingfisher

final class ImageService {
    static let shared = ImageService()
    
    func setImage(with url: URL, for imageView: UIImageView) {
        imageView.kf.setImage(with: url)
    }
    
    func setImage(
        with string: String,
        type: String,
        for imageView: UIImageView,
        placeholder: UIImage? = nil
    ) {
        guard let url = URL(string: string + type) else {
            imageView.image = placeholder
            return
        }

        setImage(with: url, for: imageView)
    }
}

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
    
    private init() { }
    
    func setImage(with url: URL, for imageView: UIImageView, placeholder: UIImage?) {
        imageView.kf.setImage(with: url) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let value):
                    imageView.image = value.image
                case .failure(_):
                    imageView.image = placeholder
                }
            }
        }
    }
    
    func setImage(
        string: String,
        for imageView: UIImageView,
        placeholder: UIImage? = nil
    ) {
        guard let url = URL(string: string) else {
            imageView.image = placeholder
            return
        }
        
        setImage(with: url, for: imageView, placeholder: placeholder)
    }
}

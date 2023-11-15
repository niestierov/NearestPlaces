//
//  UIApplication+Extension.swift
//  NearestPlaces
//
//  Created by Denys Niestierov on 14.11.2023.
//

import UIKit

extension UIApplication {
    static func openAppSettings(completion: ((Bool) -> Void)? = nil) {
        if let appSettingsURL = URL(string: UIApplication.openSettingsURLString),
           UIApplication.shared.canOpenURL(appSettingsURL) {
            UIApplication.shared.open(appSettingsURL, options: [:], completionHandler: completion)
        } else {
            completion?(false)
        }
    }
}

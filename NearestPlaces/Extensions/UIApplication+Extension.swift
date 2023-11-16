//
//  UIApplication+Extension.swift
//  NearestPlaces
//
//  Created by Denys Niestierov on 14.11.2023.
//

import UIKit

extension UIApplication {
    static func openAppSettings() {
        if let appSettingsURL = URL(string: UIApplication.openSettingsURLString),
           UIApplication.shared.canOpenURL(appSettingsURL) {
            UIApplication.shared.open(appSettingsURL, options: [:])
        }
    }
}

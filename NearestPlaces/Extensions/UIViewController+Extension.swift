//
//  UIViewController+Extension.swift
//  NearestPlaces
//
//  Created by Denys Niestierov on 09.11.2023.
//

import UIKit

extension UIViewController {    
    func showAlert(
        title: String,
        message: String,
        actions: [AlertButtonAction]
    ) {
        let alertController = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        
        actions.forEach { action in
            let alertAction = UIAlertAction(title: action.title, style: action.style) { _ in
                action.completion?()
            }
            alertController.addAction(alertAction)
        }
        
        present(alertController, animated: true, completion: nil)
    }
}


//
//  UIViewController+Extension.swift
//  NearestPlaces
//
//  Created by Denys Niestierov on 09.11.2023.
//

import UIKit

extension UIViewController {
    private enum Constant {
        static let defaultTryAgainAlertTitle = "There is an error."
        static let defaultTryAgainActionTitle = "Try Again"
        static let defaultCancelTitle = "Cancel"
    }
    
    func showAlert(
        title: String,
        message: String,
        actions: [AlertButtonAction]?
    ) {
        let alertController = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        
        actions?.forEach { action in
            let alertAction = UIAlertAction(title: action.title, style: action.style) { _ in
                action.completion?()
            }
            alertController.addAction(alertAction)
        }
        
        present(alertController, animated: true, completion: nil)
    }
    
    func showTryAgainAlert(
        title: String = Constant.defaultTryAgainAlertTitle,
        message: String,
        action: EmptyBlock? = nil
    ) {
        let cancelButton: AlertButtonAction = (Constant.defaultCancelTitle, .cancel, nil)
        let tryAgainButton: AlertButtonAction = (Constant.defaultTryAgainActionTitle, .default, action)
        
        showAlert(
            title: title,
            message: message,
            actions: [cancelButton, tryAgainButton]
        )
    }
}


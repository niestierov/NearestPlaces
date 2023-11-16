//
//  UIViewController+Extension.swift
//  NearestPlaces
//
//  Created by Denys Niestierov on 09.11.2023.
//

import UIKit

extension UIViewController {
    private enum Constant {
        static let defaultTryAgainAlertTitle = "Error"
        static let defaultTryAgainActionTitle = "Try Again"
        static let defaultCancelTitle = "Cancel"
    }
    
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
    
    func showTryAgainAlert(
        title: String = Constant.defaultTryAgainAlertTitle,
        message: String,
        action: @escaping EmptyBlock
    ) {
        let cancelButton = AlertButtonAction(
            title: Constant.defaultCancelTitle,
            style: .cancel,
            completion: nil
        )
        let tryAgainButton = AlertButtonAction(
            title: Constant.defaultTryAgainActionTitle,
            style: .default,
            completion: action
        )
        
        showAlert(
            title: title,
            message: message,
            actions: [cancelButton, tryAgainButton]
        )
    }
}


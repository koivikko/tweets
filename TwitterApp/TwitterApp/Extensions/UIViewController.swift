//
//  UIViewController.swift
//  TwitterApp
//
//  Created by Heikki on 2018-11-22.
//  Copyright © 2018 Heikki. All rights reserved.
//

import Foundation
import UIKit


extension UIViewController {
    
    func showLoadingView() {
        let loadingViewController = LoadingViewController(nibName: "LoadingView", bundle: Bundle.main)
        loadingViewController.modalPresentationStyle = .overCurrentContext
        self.present(loadingViewController, animated: false, completion: nil)
    }
    
    func dismissLoadingView() {
        self.dismiss(animated: false, completion: nil)
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
            
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func showNetworkError(error: NSError?) {
        switch error?.code {
        case RequestErrorCode.noUsername.rawValue:
            self.showAlert(message: "Username is missing.")
        case RequestErrorCode.noPassword.rawValue:
            self.showAlert(message: "Password is missing.")
        case RequestErrorCode.invalidUsernameOrPassword.rawValue:
            self.showAlert(message: "Invalid username or password.")
        case RequestErrorCode.noNetwork.rawValue:
            self.showAlert(message: "No network available, please try again later.")
        case RequestErrorCode.serverError.rawValue:
            self.showAlert(message: "Internal server error, please try again later.")
        default:
            self.showAlert(message: "Unknown error.")
        }
    }
}

//
//  ViewController.swift
//  TwitterApp
//
//  Created by Heikki on 2018-11-19.
//  Copyright © 2018 Heikki. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let accountManager = AccountManager.sharedInstance
        if let currentAccount = accountManager.currentAccount() {
            if (accountManager.isLoggedIn(account: currentAccount)) {
                // Show tweets list
            } else {
                // Ask for the password
            }
        } else {
            // Ask for username and password
            let loginViewController = LoginViewController(account: nil, nibName: "LoginView", bundle: Bundle.main)
            self.navigationController?.pushViewController(loginViewController, animated: true)
            
        }
    }


}


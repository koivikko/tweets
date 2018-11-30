//
//  ViewController.swift
//  TwitterApp
//
//  Created by Heikki on 2018-11-19.
//  Copyright © 2018 Heikki. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidLoad()
        
        // In this exercise, this main view controller is responsible for displaying login screen or the tweets list based on the account status
        // For now, this works well since the app only has those two main states: not logged in or logged in
        // In practice, this won't produce a smooth experience and some other navigation approach might work better
        let accountManager = AccountManager.sharedInstance()
        if let currentAccount = accountManager.currentAccount() {
            // Show tweets list
            let tweetsViewController = TweetsViewController(account: currentAccount, nibName: "TweetsView", bundle: Bundle.main)
            self.navigationController?.pushViewController(tweetsViewController, animated: true)
        } else {
            // Ask for username and password
            let loginViewController = LoginViewController(account: nil, nibName: "LoginView", bundle: Bundle.main)
            self.navigationController?.pushViewController(loginViewController, animated: true)            
        }
    }


}


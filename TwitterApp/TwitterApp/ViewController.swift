//
//  ViewController.swift
//  TwitterApp
//
//  Created by Heikki on 2018-11-19.
//  Copyright © 2018 Heikki. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidLoad()
                
        let accountManager = AccountManager.sharedInstance
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


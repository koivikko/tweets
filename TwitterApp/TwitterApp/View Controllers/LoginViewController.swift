//
//  LoginViewController.swift
//  TwitterApp
//
//  Created by Heikki on 2018-11-19.
//  Copyright © 2018 Heikki. All rights reserved.
//

import Foundation
import UIKit

class LoginViewController: UIViewController {
    
    let account: Account?
    
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    init(account: Account?, nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        self.account = account
        if account != nil {
            // Login view was displayed with a previous account, don't allow switching accounts by locking username field
            usernameField.isUserInteractionEnabled = false
            usernameField.text = account?.username
        }
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.account = nil
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // No option to go back from login screen for now
        self.navigationController?.isNavigationBarHidden = true
    }
    
    @IBAction func loginTapped(_ sender: Any) {
        if let username = self.usernameField.text, let password = self.passwordField.text {
            
            showLoadingView()
            
            let accountManager = AccountManager.sharedInstance
            accountManager.login(username: username, password: password) {(requestStatus, error) in
                
                // Since login is an asynchronous operation, make sure we handle results in the main thread
                DispatchQueue.main.async {
                    
                    self.dismissLoadingView()
                    
                    if requestStatus == .success {
                        let currentAccount = accountManager.currentAccount()
                        let tweetsViewController = TweetsViewController(account: currentAccount, nibName: "TweetsView", bundle: Bundle.main)
                        self.navigationController?.pushViewController(tweetsViewController, animated: true)
                    } else {
                        // Display login error
                        self.showNetworkError(error: error)
                    }
                }
            }
            
            
        }
    }
    
}

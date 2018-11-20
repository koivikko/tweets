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
            // Don't allow switching accounts
            usernameField.isUserInteractionEnabled = false
        }
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.account = nil
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        usernameField?.text = "heikki"
    }
    
    @IBAction func loginTapped(_ sender: Any) {
        if let username = self.usernameField.text, let password = self.passwordField.text {
            let accountManager = AccountManager.sharedInstance
            accountManager.login(username: username, password: password) {(requestStatus, error) in
                
                // Since login is an asynchronous operation, make sure we handle results in the main thread
                DispatchQueue.main.async {
                    if requestStatus == RequestStatus.success {
                        print("Login successful")
                        self.navigationController?.popViewController(animated: true)
                    } else {
                        // Display login error
                    }
                }
            }
            
            
        }
    }
    
}

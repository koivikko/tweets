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
    
    var account: Account?
    
    @IBOutlet weak var usernameField: UITextField!
    
    init(account: Account?, nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.account = account
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.usernameField?.text = "heikki"
    }
    
    
}

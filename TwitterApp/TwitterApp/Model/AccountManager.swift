//
//  AccountManager.swift
//  TwitterApp
//
//  Created by Heikki on 2018-11-19.
//  Copyright © 2018 Heikki. All rights reserved.
//

import Foundation


struct Account {
    
    let username : String
    let uuid: UUID
    
}

class AccountManager {

    static let accountManagerLoginErrorDomain = "AccountManagerLoginErrorDomain"
    
    static let sharedInstance = AccountManager()
    
    private init() {
    }
    
    func currentAccount() -> Account? {
        return nil
    }
    
    func login(username: String, password: String, onComplete: @escaping (_ loginStatus: RequestStatus, _ error: NSError?) -> Void) {
        let restApi = TweetRESTApi.sharedInstance
        restApi.loginWith(username: username, password: password) {loginStatus, error in
            if loginStatus == RequestStatus.success {
                // Store the account
            } else {
                // Erase the password
            }
            // send the status upstream
            onComplete(loginStatus, error)
        }
    }
    
    func logout(account: Account) {
        
    }
    
    func isLoggedIn(account: Account!) -> Bool {
        return true
    }
 
}

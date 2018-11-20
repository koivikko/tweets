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
    
}

enum AccountLoginStatus: Int {
    case LoginStarted
    case InvalidPassword
    case InvalidUsername
    case LoginFailed
}



class AccountManager {

    static let accountManagerLoginErrorDomain = "AccountManagerLoginErrorDomain"
    
    static let sharedInstance = AccountManager()
    
    private init() {
    }
    
    func currentAccount() -> Account? {
        return nil
    }
    
    func login(username: String, password: String) -> (AccountLoginStatus, NSError)  {
        return (AccountLoginStatus.LoginFailed, NSError(domain: AccountManager.accountManagerLoginErrorDomain, code: AccountLoginStatus.LoginFailed.rawValue, userInfo: nil))
    }
    
    func logout(account: Account) {
        
    }
    
    func isLoggedIn(account: Account!) -> Bool {
        return true
    }
 
}

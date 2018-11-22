//
//  AccountManager.swift
//  TwitterApp
//
//  Created by Heikki on 2018-11-19.
//  Copyright © 2018 Heikki. All rights reserved.
//

import Foundation


struct Account: Codable {
    
    let username: String
    let uuid: String
    let password: String
    
}

class AccountManager {

    static let accountManagerLoginErrorDomain = "AccountManagerLoginErrorDomain"
    static let filePath = FileManager.documentsDir() + "/Account.txt"
    
    static let sharedInstance = AccountManager()
    
    private init() {
    }
    
    func currentAccount() -> Account? {
        return loadAccount()
    }
    
    func login(username: String, password: String, onComplete: @escaping (_ loginStatus: RequestStatus, _ error: NSError?) -> Void) {
        let restApi = TweetRESTApi.sharedInstance
        restApi.loginWith(username: username, password: password) {loginStatus, error in
            if loginStatus == RequestStatus.success {
                // Store the account
                let account = Account(username: username, uuid: UUID().uuidString, password: password)
                self.saveAccount(account: account)
            } else {
                // For now just delete account, in real life, erase password etc. depending on the error code
                self.deleteAccount()
            }
            // send the status upstream
            onComplete(loginStatus, error)
        }
    }
    
    func logout(account: Account) {
        deleteAccount()
        let tweetManager = TweetManager.sharedInstance
        tweetManager.deleteTweets()
    }
    
    private func saveAccount(account: Account) {
        
        do {
            let jsonData = try JSONEncoder().encode(account)
            try jsonData.write(to: URL(fileURLWithPath: AccountManager.filePath))
        } catch {
            print(error)
        }
    
    }
    
    private func loadAccount() -> Account? {
        let fileManager = FileManager.default
        if !fileManager.fileExists(atPath: AccountManager.filePath) {
            return nil
        }
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: AccountManager.filePath))
            let jsonObject = try JSONDecoder().decode(Account.self, from: data)
            return jsonObject
        } catch {
            print(error)
        }
        return nil
    }
    
    private func deleteAccount() {
        let fileManager = FileManager.default
        do {
            try fileManager.removeItem(atPath: AccountManager.filePath)
        }
        catch let error as NSError {
            print(error)
        }
    }
}

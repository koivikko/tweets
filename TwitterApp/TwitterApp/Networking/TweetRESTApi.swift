//
//  TweetRESTApi.swift
//  TwitterApp
//
//  Created by Heikki on 2018-11-20.
//  Copyright © 2018 Heikki. All rights reserved.
//

import Foundation

// Generic request status codes to be returned to the callers
enum RequestStatus: Int {
    case success
    case failed
    case canceled
}

// Sample network error codes
enum RequestErrorCode: Int {
    case noUsername
    case noPassword
    case invalidUsernameOrPassword
    case noNetwork
    case serverError
}

// REST api protocol to be used by the data model
protocol RESTApiProtocol {
    func loginWith(username: String, password: String, onComplete: @escaping (_ loginStatus: RequestStatus, _ error: NSError?) -> Void)
    
    func refreshTweets(account: Account, onComplete: @escaping (_ loginStatus: RequestStatus, _ error: NSError?, _ tweets: Array<Tweet>?) -> Void)
    
    func postTweet(account: Account, tweet: Tweet, onComplete: @escaping (_ loginStatus: RequestStatus, _ error: NSError?) -> Void)
}

// Actual rest API implementation
class TweetRESTApi: RESTApiProtocol {
    
    static let TweetRESTApiErrorDomain = "TweetRESTApiErrorDomain"
    
    private let networkOperationsQueue: OperationQueue
    
    init() {
        networkOperationsQueue = {
            let queue = OperationQueue()
            queue.name = "Network operations queue"
            queue.maxConcurrentOperationCount = 1
            return queue
        }()
    }
    
    func loginWith(username: String, password: String, onComplete: @escaping (_ loginStatus: RequestStatus, _ error: NSError?) -> Void) {
        if username.count <= 0 {
            onComplete(RequestStatus.failed, NSError(domain: TweetRESTApi.TweetRESTApiErrorDomain, code: RequestErrorCode.noUsername.rawValue, userInfo: nil))
        }
        if password.count <= 0 {
            onComplete(RequestStatus.failed, NSError(domain: TweetRESTApi.TweetRESTApiErrorDomain, code: RequestErrorCode.noPassword.rawValue, userInfo: nil))
        }
        
        // Preconditions seem to be ok, proceed with the fake request
        let loginOperation = LoginOperation(username: username, password: password, onComplete: onComplete)
        networkOperationsQueue.addOperation(loginOperation)
    }
    
    func refreshTweets(account: Account, onComplete: @escaping (_ loginStatus: RequestStatus, _ error: NSError?, _ tweets: Array<Tweet>?) -> Void) {
        
        // proceed with the fake request
        let refreshOperation = RefreshTweetsOperation(account: account, onComplete: onComplete)
        networkOperationsQueue.addOperation(refreshOperation)
    }
    
    func postTweet(account: Account, tweet: Tweet, onComplete: @escaping (_ loginStatus: RequestStatus, _ error: NSError?) -> Void) {
        
        // proceed with the fake request
        let postTweetOperation = PostTweetOperation(account: account, tweet: tweet, onComplete: onComplete)
        networkOperationsQueue.addOperation(postTweetOperation)
    }
}

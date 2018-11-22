//
//  TweetRESTApi.swift
//  TwitterApp
//
//  Created by Heikki on 2018-11-20.
//  Copyright © 2018 Heikki. All rights reserved.
//

import Foundation

enum RequestStatus: Int {
    case success
    case failed
    case canceled
}

enum RequestErrorCode: Int {
    case noUsername
    case noPassword
    case invalidUsernameOrPassword
    case noNetwork
    case serverError
}


class LoginOperation: Operation {
    
    let username: String
    let password: String
    
    var onComplete: (_ loginStatus: RequestStatus, _ error: NSError?) -> Void
    
    init(username: String, password: String, onComplete: @escaping (_ loginStatus: RequestStatus, _ error: NSError?) -> Void) {
        self.onComplete = onComplete
        self.username = username
        self.password = password
    }
    
    override func main() {
        if isCancelled {
            onComplete(RequestStatus.canceled, nil)
            return
        }
        let randomLatency = Int.random(in: 0 ..< 3)
        Thread.sleep(forTimeInterval: TimeInterval(randomLatency))
        
        if isCancelled {
            onComplete(RequestStatus.canceled, nil)
            return
        }
        
        let randomFailure = Int.random(in: 0 ..< 10)
        var requestStatus = RequestStatus.success
        var error: NSError?
        
        // Add some randomness to simulate network issues such as failed authentication, server error..
        switch randomFailure {
        case RequestErrorCode.invalidUsernameOrPassword.rawValue, RequestErrorCode.noNetwork.rawValue, RequestErrorCode.serverError.rawValue:
            requestStatus = RequestStatus.failed
            error = NSError(domain: TweetRESTApi.TweetRESTApiErrorDomain, code: randomFailure, userInfo: nil)
        default:
            requestStatus = RequestStatus.success
        }
        
        
        onComplete(requestStatus, error)
        
    }
}

class RefreshTweetsOperation: Operation {
    
    let account: Account
    
    var onComplete: (_ loginStatus: RequestStatus, _ error: NSError?, _ tweets: Array<Tweet>?) -> Void
    
    init(account: Account, onComplete: @escaping (_ loginStatus: RequestStatus, _ error: NSError?, _ tweets: Array<Tweet>?) -> Void) {
        self.account = account
        self.onComplete = onComplete
    }
    
    override func main() {
        print("Starting to refresh tweets")
        if isCancelled {
            onComplete(RequestStatus.canceled, nil, nil)
            return
        }
        
        let randomLatency = Int.random(in: 0 ..< 3)
        Thread.sleep(forTimeInterval: TimeInterval(randomLatency))
        
        if isCancelled {
            onComplete(RequestStatus.canceled, nil, nil)
            return
        }
        
        var requestStatus = RequestStatus.success
        var error: NSError?
        var tweets: Array<Tweet>?
        
        // Add some randomness to simulate network issues such as failed authentication, server error..
        let randomFailure = Int.random(in: 0 ..< 30)
        switch randomFailure {
        case RequestErrorCode.invalidUsernameOrPassword.rawValue, RequestErrorCode.noNetwork.rawValue, RequestErrorCode.serverError.rawValue:
            requestStatus = RequestStatus.failed
            error = NSError(domain: TweetRESTApi.TweetRESTApiErrorDomain, code: randomFailure, userInfo: nil)
            print("Failing the request with error code = \(randomFailure)")
        default:
            requestStatus = RequestStatus.success
            // Since this is pretending to be connected to a real network, randomly add a tweet every once in a while to existing tweets
            let tweetManager = TweetManager.sharedInstance
            tweets = tweetManager.getTweets(account: account)
            let random = Int.random(in: 0 ..< 10)
            if (random % 2 == 0) {
                // Add a random tweet
                let randomTweets = ["First", "Second", "Third", "Fourth", "Fifth"]
                let randomUsers = ["Ellen", "Barack", "Donald", "Justin", "Katy"]
                let tweet = Tweet(uuid: UUID().uuidString, originatingDisplayname: randomUsers[Int.random(in: 0 ..< 5)], tweetMessage: randomTweets[Int.random(in: 0 ..< 5)], timeStamp: NSDate().timeIntervalSince1970)
                if tweets == nil {
                    tweets = Array<Tweet>()
                }
                tweets?.insert(tweet, at: 0)
            }
        }
    
        onComplete(requestStatus, error, tweets)
        print("Refresh completed with status = \(requestStatus.rawValue)")
    }
}

class PostTweetOperation: Operation {
    let account: Account
    let tweet: Tweet
    
    var onComplete: (_ loginStatus: RequestStatus, _ error: NSError?) -> Void
    
    init(account: Account, tweet: Tweet, onComplete: @escaping (_ loginStatus: RequestStatus, _ error: NSError?) -> Void) {
        self.account = account
        self.tweet = tweet
        self.onComplete = onComplete
    }
    
    override func main() {
        print("Starting to post a tweet")
        if isCancelled {
            onComplete(RequestStatus.canceled, nil)
            return
        }
        
        let randomLatency = Int.random(in: 0 ..< 3)
        Thread.sleep(forTimeInterval: TimeInterval(randomLatency))
        
        if isCancelled {
            onComplete(RequestStatus.canceled, nil)
            return
        }
        
        var requestStatus = RequestStatus.success
        var error: NSError?
        
        // Add some randomness to simulate network issues such as failed authentication, server error..
        let randomFailure = Int.random(in: 0 ..< 30)
        switch randomFailure {
        case RequestErrorCode.invalidUsernameOrPassword.rawValue, RequestErrorCode.noNetwork.rawValue, RequestErrorCode.serverError.rawValue:
            requestStatus = RequestStatus.failed
            error = NSError(domain: TweetRESTApi.TweetRESTApiErrorDomain, code: randomFailure, userInfo: nil)
            print("Failing the request with error code = \(randomFailure)")
        default:
            requestStatus = RequestStatus.success
        }
        
        onComplete(requestStatus, error)
        print("Refresh completed with status = \(requestStatus.rawValue)")
    }
}

class TweetRESTApi {
    
    static let TweetRESTApiErrorDomain = "TweetRESTApiErrorDomain"
    
    private let networkOperationsQueue: OperationQueue
    
    static let sharedInstance = TweetRESTApi()
    
    private init() {
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

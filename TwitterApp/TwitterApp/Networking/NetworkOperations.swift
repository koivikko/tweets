//
//  NetworkOperations.swift
//  TwitterApp
//
//  Created by Heikki on 2018-11-22.
//  Copyright © 2018 Heikki. All rights reserved.
//
// This class includes all fake network operations to illustrate asynchronous nature of REST api calls
//

import Foundation

class LoginOperation: Operation {
    
    let username: String
    let password: String
    
    let onComplete: (_ loginStatus: RequestStatus, _ error: NSError?) -> Void
    
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
        
        // Add some random latency
        let randomLatency = Int.random(in: 1 ..< 3)
        Thread.sleep(forTimeInterval: TimeInterval(randomLatency))
        
        if isCancelled {
            onComplete(RequestStatus.canceled, nil)
            return
        }
        
        // Make it fail 50% of time
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
    
    let onComplete: (_ loginStatus: RequestStatus, _ error: NSError?, _ tweets: Array<Tweet>?) -> Void
    
    init(account: Account, onComplete: @escaping (_ loginStatus: RequestStatus, _ error: NSError?, _ tweets: Array<Tweet>?) -> Void) {
        self.account = account
        self.onComplete = onComplete
    }
    
    override func main() {
        if isCancelled {
            onComplete(RequestStatus.canceled, nil, nil)
            return
        }
        
        // Add some random latency
        let randomLatency = Int.random(in: 1 ..< 3)
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
            let tweetManager = TweetManager.sharedInstance()
            tweets = tweetManager.getTweets(account: account)
            let random = Int.random(in: 0 ..< 10)
            if (random % 2 == 0) {
                // Add a random tweet
                let randomTweets = ["Tweet about the state of affairs.", "Retweeting something.", "Tweet for advertising my new book.", "Tweeting about some great announcements.", "Commenting some recent news."]
                let randomUsers = ["Ellen", "Barack", "Donald", "Justin", "Katy"]
                let tweet = Tweet(uuid: UUID().uuidString, originatingDisplayname: randomUsers[Int.random(in: 0 ..< 5)], tweetMessage: randomTweets[Int.random(in: 0 ..< 5)], timeStamp: NSDate().timeIntervalSince1970)
                if tweets == nil {
                    tweets = Array<Tweet>()
                }
                tweets!.insert(tweet, at: 0)
                print("A new random tweet added")
            }
        }
        
        onComplete(requestStatus, error, tweets)
        
    }
}

class PostTweetOperation: Operation {
    let account: Account
    let tweet: Tweet
    
    let onComplete: (_ loginStatus: RequestStatus, _ error: NSError?) -> Void
    
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
        
        // Add some random latency
        let randomLatency = Int.random(in: 1 ..< 3)
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
    }
}

//
//  TweetManager.swift
//  TwitterApp
//
//  Created by Heikki on 2018-11-20.
//  Copyright © 2018 Heikki. All rights reserved.
//

import Foundation

struct Tweet: Codable {
    
    let uuid: String
    let originatingDisplayname: String
    let tweetMessage: String
    let timeStamp: TimeInterval
    
}

class TweetManager {
    
    private static let filePath = FileManager.documentsDir() + "tweets.txt"
    
    private static var _shared: TweetManager?
    let restApi: RESTApiProtocol!
    
    
    private init(restApi: RESTApiProtocol) {
        self.restApi = restApi
    }
    
    static func initialize(restApi: RESTApiProtocol) {
        _shared = TweetManager(restApi: restApi)
    }
    
    static func sharedInstance() -> TweetManager {
        if _shared == nil {
            print("Calling sharedInstance() before initializing TweetManager")
        }
        return _shared!
    }
    
    func getTweets(account: Account) -> Array<Tweet>? {
        // return local tweets
        // Note: The account is ignored for now but would need to be taken in to consideration in a real app
        return loadTweets()
    }
    
    func refreshTweetsList(account: Account, onComplete: @escaping (_ loginStatus: RequestStatus, _ error: NSError?) -> Void) -> Bool {
        // Launch a refresh request
        // This method should only poll since the last time tweets were fetched.
        // For now assume unlimited resources and refresh the list always..        
        restApi.refreshTweets(account: account) {[weak self] (requestStatus, error, tweets) in
            if requestStatus == RequestStatus.success {
                if (tweets != nil) {
                    self?.saveTweets(tweets: tweets!)
                }
                // Notify UI
                onComplete(requestStatus, error)
            } else {
                // Error handling needed
                onComplete(requestStatus, error)
            }
        }
        return true
    }
    
    func postTweet(account: Account, message: String, onComplete: @escaping (_ loginStatus: RequestStatus, _ error: NSError?) -> Void) {
        
        // Create a tweet object
        let tweet = Tweet(uuid: UUID().uuidString, originatingDisplayname: account.username, tweetMessage: message, timeStamp: Date().timeIntervalSince1970)
        
        // launch a refresh request
        restApi.postTweet(account: account, tweet: tweet) {[weak self] (requestStatus, error) in
            if requestStatus == RequestStatus.success {
                // Faking the network roundtrip by adding this tweet to stored tweets
                var tweets = self?.loadTweets()
                if tweets == nil {
                    tweets = Array<Tweet>()
                }
                tweets!.insert(tweet, at: 0)
                self?.saveTweets(tweets: tweets!)
                onComplete(requestStatus, error)
            } else {
                onComplete(requestStatus, error)
            }
        }
    }
    
    // Allows clearing the tweets from the storage.
    // This would need to be hidden and done properly in a real app but is now exposed on purpose
    func deleteTweets() {
        let fileManager = FileManager.default
        if !fileManager.fileExists(atPath: TweetManager.filePath) {
            return
        }
        do {
            try fileManager.removeItem(atPath: TweetManager.filePath)
        } catch {
            print(error)
        }
    }
    
    // MAKR: private methods
    private func loadTweets() -> Array<Tweet>? {
        let fileManager = FileManager.default
        if !fileManager.fileExists(atPath: TweetManager.filePath) {
            return nil
        }
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: TweetManager.filePath))
            let jsonObject = try JSONDecoder().decode(Array<Tweet>.self, from: data)
            return jsonObject
        } catch {
            print(error)
        }
        return nil
    }
    
    private func saveTweets(tweets: Array<Tweet>) {
        do {
            let jsonData = try JSONEncoder().encode(tweets)
            try jsonData.write(to: URL(fileURLWithPath: TweetManager.filePath))
        } catch {
            print(error)
        }
    }
    
}

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
    
    static let sharedInstance = TweetManager()
    
    private static let filePath = FileManager.documentsDir() + "tweets.txt"
    
    func getTweets(account: Account) -> Array<Tweet>? {
        // return local tweets
        return loadTweets()
    }
    
    func refreshTweetsList(account: Account, onComplete: @escaping (_ loginStatus: RequestStatus, _ error: NSError?) -> Void) -> Bool {
        // launch a refresh request
        let restApi = TweetRESTApi.sharedInstance
        restApi.refreshTweets(account: account) {(requestStatus, error, tweets) in
            if requestStatus == RequestStatus.success {
                if (tweets != nil) {
                    self.saveTweets(tweets: tweets!)
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
    
    func postTweet(account: Account, message: String, onComplete: @escaping (_ loginStatus: RequestStatus, _ error: NSError?) -> Void) -> Bool {
        
        // Create a tweet object
        let tweet = Tweet(uuid: UUID().uuidString, originatingDisplayname: account.username, tweetMessage: message, timeStamp: Date().timeIntervalSince1970)
        
        // launch a refresh request
        let restApi = TweetRESTApi.sharedInstance
        restApi.postTweet(account: account, tweet: tweet) {(requestStatus, error) in
            if requestStatus == RequestStatus.success {
                // Faking the network roundtrip by adding this tweet to stored tweets
                var tweets = self.loadTweets()
                if tweets == nil {
                    tweets = Array<Tweet>()
                }
                tweets!.insert(tweet, at: 0)
                self.saveTweets(tweets: tweets!)
                onComplete(requestStatus, error)
            } else {
                onComplete(requestStatus, error)
            }
        }
        return true
    }
    
    
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
}

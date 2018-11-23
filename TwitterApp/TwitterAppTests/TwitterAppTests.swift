//
//  TwitterAppTests.swift
//  TwitterAppTests
//
//  Created by Heikki on 2018-11-19.
//  Copyright © 2018 Heikki. All rights reserved.
//

import XCTest
@testable import TwitterApp

// A stub rest api in order to test tweet manager synchronously
// Methods could be populated as needed
class RESTApiForTests: RESTApiProtocol {
    
    func loginWith(username: String, password: String, onComplete: @escaping (RequestStatus, NSError?) -> Void) {
        onComplete(.success, nil)
    }
    
    func refreshTweets(account: Account, onComplete: @escaping (RequestStatus, NSError?, Array<Tweet>?) -> Void) {
        onComplete(.success, nil, nil)
    }
    
    func postTweet(account: Account, tweet: Tweet, onComplete: @escaping (RequestStatus, NSError?) -> Void) {
        onComplete(.success, nil)
    }
    
}

class TwitterAppTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let restAPIStub = RESTApiForTests()
        TweetManager.initialize(restApi: restAPIStub)
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        let tweetManager = TweetManager.sharedInstance()
        tweetManager.deleteTweets()
    }

    func testThatTweetManagerSavesTweetsWhenPosted() {
        // given
        let account = Account(username: "usernameX", uuid: UUID().uuidString, password: "passwordX")
        let tweetManager = TweetManager.sharedInstance()
        
        // when
        tweetManager.postTweet(account: account, message: "tweetOne") { (_, _) in
            
        }
        // then
        let tweets = tweetManager.getTweets(account: account)
        XCTAssertNotNil(tweets)
        let tweet = tweets?[0]
        XCTAssertEqual("tweetOne", tweet?.tweetMessage)
        XCTAssertEqual("usernameX", tweet?.originatingDisplayname)
    }
    
    func testThatTweetManagerDeletesTweets() {
        // given
        let account = Account(username: "usernameX", uuid: UUID().uuidString, password: "passwordX")
        let tweetManager = TweetManager.sharedInstance()
        
        // when
        tweetManager.postTweet(account: account, message: "tweetOne") { (_, _) in
            
        }
        // then
        tweetManager.deleteTweets()
        let tweets = tweetManager.getTweets(account: account)
        XCTAssertNil(tweets)
    }
    

}

//
//  TweetRESTApi.swift
//  TwitterApp
//
//  Created by Heikki on 2018-11-20.
//  Copyright © 2018 Heikki. All rights reserved.
//

import Foundation

struct Tweet {
    
    let uuid: UUID
    let originatingUsername: String
    let originatingDisplayname: String
    let tweetMessage: String
    let timeStamp: NSDate
    
}

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

protocol NetworkOperation {
    
    var onComplete: (_ loginStatus: RequestStatus, _ error: NSError?) -> Void {get}
    
}

class LoginOperation: Operation, NetworkOperation {
    
    var onComplete: (_ loginStatus: RequestStatus, _ error: NSError?) -> Void
    
    init(onComplete: @escaping (_ loginStatus: RequestStatus, _ error: NSError?) -> Void) {
        self.onComplete = onComplete
    }
    
    override func main() {
        if isCancelled {
            onComplete(RequestStatus.canceled, nil)
            return
        }
        let randomLatency = Int.random(in: 0 ..< 10)
        Thread.sleep(forTimeInterval: TimeInterval(randomLatency))
        
        let randomFailure = Int.random(in: 0 ..< 10)
        var requestStatus = RequestStatus.success
        var error: NSError?
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
        let loginOperation = LoginOperation(onComplete: onComplete)
        networkOperationsQueue.addOperation(loginOperation)
    }
    
}

//
//  TweetComposeViewController.swift
//  TwitterApp
//
//  Created by Heikki on 2018-11-21.
//  Copyright © 2018 Heikki. All rights reserved.
//

import Foundation
import UIKit

class TweetComposeViewController: UIViewController {
    
    let account: Account!
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var tweetMessage: UITextView!
    
    init(account: Account!, nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        self.account = account
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.account = nil
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        usernameLabel.text = account?.username
        self.navigationController?.isNavigationBarHidden = false
    }
    
    @IBAction func tweetButtonTapped(_ sender: Any) {
        if tweetMessage.text.count <= 0 {
            // Cannot post an empty tweet
            // Display an error
        } else {
            let tweetManager = TweetManager.sharedInstance
            let success = tweetManager.postTweet(account: account!, message: tweetMessage.text) {(requestStatus, error) in
                DispatchQueue.main.async {                    
                    if requestStatus == .success {
                        self.navigationController?.popViewController(animated: true)
                    } else {
                        // Show an error
                    }
                }
            }
            if !success {
                print("Error when posting a tweet")
            }
        }
    }
    
}

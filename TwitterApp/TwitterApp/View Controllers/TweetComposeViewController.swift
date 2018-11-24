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
    
    // MARK: IBActions
    
    @IBAction func tweetButtonTapped(_ sender: Any) {
        if tweetMessage.text.count <= 0 {
            // Cannot post an empty tweet
            // Display an error
            self.showAlert(message: "Message cannot be empty.")
        } else {
            showLoadingView()
            let tweetManager = TweetManager.sharedInstance()
            tweetManager.postTweet(account: account!, message: tweetMessage.text) {[weak self] (requestStatus, error) in
                DispatchQueue.main.async {
                    self?.dismissLoadingView()
                    if requestStatus == .success {
                        self?.navigationController?.popViewController(animated: true)
                    } else {
                        // Show an error
                        self?.showNetworkError(error: error)
                    }
                }
            }
        }
    }
    
}

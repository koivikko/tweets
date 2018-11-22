//
//  TweetsViewController.swift
//  TwitterApp
//
//  Created by Heikki on 2018-11-20.
//  Copyright © 2018 Heikki. All rights reserved.
//

import Foundation
import UIKit

class TweetsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let account: Account?
    var tweets: Array<Tweet>?
    
    @IBOutlet weak var tableView: UITableView!
    
    
    init(account: Account?, nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        self.account = account
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.account = nil
        super.init(coder: aDecoder)
    }
    
    @objc private func handleRefresh(_ refreshControl: UIRefreshControl) {
        refreshTweetsList()
    }
    
    func refreshTweetsList() {
        let tweetManager = TweetManager.sharedInstance
        self.tableView.refreshControl?.beginRefreshing()
        if !tweetManager.refreshTweetsList(account: account!) {(requestStatus, error) in
            DispatchQueue.main.async {
                self.tableView.refreshControl?.endRefreshing()
                if requestStatus == .success {
                    let tweetManager = TweetManager.sharedInstance
                    self.tweets = tweetManager.getTweets(account: self.account!)
                    self.tableView.reloadData()
                } else {
                    // Display error
                    self.showNetworkError(error: error)
                }
            }
            } {
            // For now this shouldn't happen ever..
            print("Could not refresh tweets")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(TweetsViewController.handleRefresh(_:)), for: UIControl.Event.valueChanged)
        refreshControl.tintColor = UIColor.gray
        tableView.refreshControl = refreshControl
        
        let nib = UINib.init(nibName: "TweetTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "tweetTableViewCell")
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
        if (account != nil) {
            // Always check for new tweets
            refreshTweetsList()
            
            // Reload local tweets as well
            let tweetManager = TweetManager.sharedInstance
            tweets = tweetManager.getTweets(account: account!)
            self.tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: TweetTableViewCell = tableView.dequeueReusableCell(withIdentifier: "tweetTableViewCell", for: indexPath) as! TweetTableViewCell
        
        guard let tweet = tweets?[indexPath.row] else {
            // Protecting against invalid range
            return cell
        }
        cell.usernameLabel.text = tweet.originatingDisplayname
        cell.tweetTextLabel.text = tweet.tweetMessage
        let dateTime = Date(timeIntervalSince1970: tweet.timeStamp)
        let since = abs(Int(dateTime.timeIntervalSinceNow))
        if since < 60 {
            // display in seconds
            cell.timestampLabel.text = "\(since)s"
        } else if since < 3600 {
            // display in minutes
            cell.timestampLabel.text = "\(since / 60)m"
        } else {
            // display in hourse
            cell.timestampLabel.text = "\(since / 3600)h"
        }
        
        
        return cell
        
    }
    
    @IBAction func composeTapped(_ sender: Any) {
        let tweetComposeViewController = TweetComposeViewController(account: account, nibName: "TweetComposeView", bundle: Bundle.main)
        self.navigationController?.pushViewController(tweetComposeViewController, animated: true)
    }
    
    @IBAction func logoutTapped(_ sender: Any) {
        if account != nil {
            let accountManager = AccountManager.sharedInstance
            accountManager.logout(account: account!)
        }
        self.navigationController?.popViewController(animated: true)
    }
    
}

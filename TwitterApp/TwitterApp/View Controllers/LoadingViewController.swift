//
//  LoadingViewController.swift
//  TwitterApp
//
//  Created by Heikki on 2018-11-22.
//  Copyright © 2018 Heikki. All rights reserved.
//

import Foundation
import UIKit

class LoadingViewController: UIViewController {
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var activityView: UIActivityIndicatorView!
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        contentView.layer.cornerRadius = 5;
        contentView.layer.masksToBounds = true;
    }
    
    override func viewDidAppear(_ animated: Bool) {
        activityView.startAnimating()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        activityView.stopAnimating()
    }
    
}

//
//  XCUIApplication.swift
//  TwitterAppUITests
//
//  Created by Heikki on 2018-11-22.
//  Copyright © 2018 Heikki. All rights reserved.
//

import Foundation
import XCTest


extension XCUIApplication {
    
    func currentScreenIsLogin() -> Bool {
        return otherElements["loginView"].exists
    }
    
}

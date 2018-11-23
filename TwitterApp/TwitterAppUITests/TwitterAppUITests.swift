//
//  TwitterAppUITests.swift
//  TwitterAppUITests
//
//  Created by Heikki on 2018-11-19.
//  Copyright © 2018 Heikki. All rights reserved.
//

import XCTest

class TwitterAppUITests: XCTestCase {
    var app: XCUIApplication!

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        app = XCUIApplication()
        app.launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testThatLoginLogoutWorks() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        XCTAssertTrue(app.currentScreenIsLogin())
        
        app.textFields["usernameField"].tap()
        app.textFields["usernameField"].typeText("UItestUser")
        app.textFields["passwordField"].tap()
        app.textFields["passwordField"].typeText("password")
        
        app.buttons["loginButton"].tap()
        
        // wait for the loading view to show up
        let loadingView = app.otherElements["loadingView"]
        let loadingViewShown = loadingView.waitForExistence(timeout: 2)
        XCTAssertTrue(loadingViewShown)

        // next wait for the tweets view to show up
        // NOTE: Since the app includes a fake network stack with random failures, this test has a somewhat high chance of failing. This is a known issue for now and won't be covered in this exercise
        //   - There would be few different ways of handling this
        let tweetsView = app.otherElements["tweetsView"]
        let tweetsViewShown = tweetsView.waitForExistence(timeout: 10)
        XCTAssertTrue(tweetsViewShown)
        
        // last, logout to reset the app state
        app.toolbars.buttons["logoutButton"].tap()
        
        XCTAssertTrue(app.currentScreenIsLogin())
        
    }

}

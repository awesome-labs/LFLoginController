//
//  LFLoginControllerUITests.swift
//  LFLoginControllerUITests
//
//  Created by Lucas Farah on 11/18/16.
//  Copyright © 2016 Lucas Farah. All rights reserved.
//

import XCTest

class LFLoginControllerUITests: XCTestCase {
    
    var app: XCUIElement?
    
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        app = XCUIApplication()
        
        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func completeInformation() {
        
        let email = XCUIApplication().textFields.element(boundBy: 0)
        email.tap()
        UIPasteboard.general.string = "lucas.farah@me.com"
        email.press(forDuration: 1.1)
        app?.menuItems["Paste"].tap()
        
        let password = app?.secureTextFields["Password"]
        password?.tap()
        UIPasteboard.general.string = "1234"
        password?.press(forDuration: 1.1)
        app?.menuItems["Paste"].tap()
    }
    
    func testLogin() {
        
        let app = XCUIApplication()
        app.buttons["Login"].tap()
        completeInformation()
        app.buttons["Login"].tap()
    }
    
    func testSignup() {
        
        let app = XCUIApplication()
        app.buttons["Login"].tap()
        completeInformation()
        print(app.buttons)
        let button = app.buttons["Don't have an account? Sign up"]
        button.tap()
        app.buttons["Signup"].tap()
    }
    
}

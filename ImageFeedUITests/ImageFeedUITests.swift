//
//  ImageFeedUITests.swift
//  ImageFeedUITests
//
//  Created by Кирилл Арефьев on 10.02.2024.
//

import XCTest

final class ImageFeedUITests: XCTestCase {
    private var app: XCUIApplication!
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments = ["testMode"]
        app.launch()
    }
    
    func testAuth() throws {
        app.buttons["Authenticate"].tap()
        
        let webView = app.webViews["UnsplashWebView"]
        XCTAssertTrue(webView.waitForExistence(timeout: 5))
        
        let loginTextField = webView.descendants(matching: .textField).element
        XCTAssertTrue(loginTextField.waitForExistence(timeout: 5))
        loginTextField.tap()
        loginTextField.typeText("")
        app.buttons["Done"].tap()
        
        let passwordTextField = webView.descendants(matching: .secureTextField).element
        XCTAssertTrue(passwordTextField.waitForExistence(timeout: 5))
        passwordTextField.tap()
        passwordTextField.typeText("")
        app.buttons["Done"].tap()
        
        webView.buttons["Login"].tap()
        
        let tablesQuery = app.tables
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
        
        XCTAssertTrue(cell.waitForExistence(timeout: 5))
    }
    
    func testFeed() throws {
        sleep(3)
        let tableQuery = app.tables
        let cell = tableQuery.children(matching: .cell).element(boundBy: 0)
        cell.swipeUp()
        sleep(3)
        
        let cellToLike = tableQuery.children(matching: .cell).element(boundBy: 1)
        cellToLike.buttons["favoriteButton"].tap()
        sleep(3)
        cellToLike.buttons["favoriteButton"].tap()
        sleep(3)
        
        cellToLike.tap()
        sleep(5)
        
        let image = app.scrollViews.images.element(boundBy: 0)
        image.pinch(withScale: 3, velocity: 1)
        image.pinch(withScale: 0.5, velocity: -1)
        
        let backButton = app.buttons["backButton"]
        backButton.tap()
    }
    
    func testProfile() throws {
        sleep(3)
        app.tabBars.buttons.element(boundBy: 1).tap()
        sleep(3)
        
        XCTAssertTrue(app.staticTexts["userNameLabel"].exists)
        XCTAssertTrue(app.staticTexts["loginLabel"].exists)
        
        app.buttons["backButton"].tap()
        
        app.alerts["Пока, пока!"].scrollViews.otherElements.buttons["Да"].tap()
        sleep(3)
        XCTAssertTrue(app.buttons["Authenticate"].exists)
    }
}

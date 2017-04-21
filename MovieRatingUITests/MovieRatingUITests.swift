
//
//  MovieRatingUITests.swift
//  MovieRatingUITests
//
//  Created by Ephraim Kunz on 9/17/16.
//  Copyright © 2016 Ephraim Kunz. All rights reserved.
//

import XCTest

class MovieRatingUITests: XCTestCase {
    let app = XCUIApplication()
        
    override func setUp() {
        super.setUp()
        XCUIDevice.shared().orientation = .faceUp
        XCUIDevice.shared().orientation = .faceUp
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testHistoryView() {
        app.navigationBars["Scan"].buttons["historyIcon"].tap()
        let historyNavigationBar = app.navigationBars["History"]
        XCTAssert(!historyNavigationBar.buttons["Delete"].isEnabled)
        XCTAssert(historyNavigationBar.buttons["Camera"].isEnabled)
        historyNavigationBar.buttons["Camera"].tap()
    }
    
    func testSettingsView(){
        app.navigationBars["Scan"].buttons["settingsIcon"].tap()
        XCTAssert(app.tables.staticTexts["MovieRating was created and is maintained by Ephraim Kunz and is free as a courtesy to you."].exists)
        app.tables.buttons["Leave feedback"].tap()
        
        XCTAssertFalse(app.navigationBars["Feedback for MovieRating"].buttons["Done"].exists)
        
        let cancelButton = app.navigationBars["Feedback for MovieRating"].buttons["Cancel"]
        cancelButton.tap()
        
        let sheetsQuery = app.sheets
        let collectionViewsQuery = sheetsQuery.collectionViews
        let deleteDraftButton = collectionViewsQuery.buttons["Delete Draft"]
        deleteDraftButton.tap()
        app.navigationBars["Settings"].buttons["Done"].tap()
    }
}

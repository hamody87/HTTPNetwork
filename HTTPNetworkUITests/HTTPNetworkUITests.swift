//
//  HTTPNetworkUITests.swift
//  HTTPNetworkUITests
//
//  Created by Muhammad Jbara on 08/08/2021.
//

import XCTest

class WhenPlayButtonIsPressed: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func testShouldCheckResponseUrls() throws {
        
        let app = XCUIApplication()
        app.launch()
        
        let playButton = app.buttons["PlayBtnID"]
        playButton.tap()
    }

}

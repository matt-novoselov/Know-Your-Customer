//
//  Know Your Customer UITests.swift
//  Know Your Customer UITests
//
//  Created by Matt Novoselov on 18/07/25.
//

import XCTest

final class KYCUITests: XCTestCase {
    // UI tests covering the main onboarding flow.
    var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    override func tearDownWithError() throws {
        app = nil
    }

    /// Runs through the default onboarding flow using the preloaded Netherlands configuration.
    @MainActor
    func testCompleteKYCFlow() throws {
        // Welcome screen -> tap start button
        let newUserButton = app.buttons["Sign Up"]
        XCTAssertTrue(newUserButton.waitForExistence(timeout: 2))
        newUserButton.tap()

        // Country selection
        XCTAssertTrue(app.staticTexts["Choose your country"].waitForExistence(timeout: 2))
        app.buttons["Continue"].tap()

        // Personal details list
        XCTAssertTrue(app.staticTexts["Personal Details"].waitForExistence(timeout: 2))

        // Fill BSN field which is not pre-populated
        let bsnField = app.textFields["Enter BSN"]
        XCTAssertTrue(bsnField.waitForExistence(timeout: 5))
        bsnField.tap()
        bsnField.typeText("123456789")

        // Proceed to summary
        app.buttons["Continue"].tap()

        // Summary screen
        XCTAssertTrue(app.staticTexts["Collected Data"].waitForExistence(timeout: 2))
        XCTAssertTrue(app.staticTexts["123456789"].waitForExistence(timeout: 2))
    }

    /// Enters an invalid BSN value and verifies that the validation
    /// message is displayed.
    @MainActor
    func testInvalidBSNShowsError() throws {
        let newUserButton = app.buttons["Sign Up"]
        XCTAssertTrue(newUserButton.waitForExistence(timeout: 2))
        newUserButton.tap()

        XCTAssertTrue(app.staticTexts["Choose your country"].waitForExistence(timeout: 2))
        app.buttons["Continue"].tap()

        XCTAssertTrue(app.staticTexts["Personal Details"].waitForExistence(timeout: 2))

        let bsnField = app.textFields["Enter BSN"]
        XCTAssertTrue(bsnField.waitForExistence(timeout: 5))
        bsnField.tap()
        bsnField.typeText("123")

        app.buttons["Continue"].tap()

        XCTAssertTrue(app.staticTexts["BSN must be 9 digits"].waitForExistence(timeout: 1))
    }
}

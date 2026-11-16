import XCTest

final class WouldYouRatherUITests: XCTestCase {
    func testLaunchesToHomeScreen() {
        let app = XCUIApplication()
        app.launch()

        XCTAssertTrue(app.otherElements["home-screen"].waitForExistence(timeout: 5))
        XCTAssertTrue(app.staticTexts["Would You Rather?"].exists)
    }

    func testPlayerCanStartAndAdvanceGame() {
        let app = XCUIApplication()
        app.launch()

        app.buttons["play-now-button"].tap()
        app.staticTexts["Choose this side"].firstMatch.tap()

        XCTAssertTrue(app.buttons["next-question-button"].waitForExistence(timeout: 3))
        app.buttons["next-question-button"].tap()
        XCTAssertTrue(app.staticTexts["Choose this side"].firstMatch.exists)
    }
}

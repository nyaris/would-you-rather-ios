import XCTest

final class WouldYouRatherUITests: XCTestCase {
    func testLaunchesToHomeScreen() {
        let app = XCUIApplication()
        app.launch()

        XCTAssertTrue(app.otherElements["home-screen"].waitForExistence(timeout: 5))
        XCTAssertTrue(app.staticTexts["Would You Rather?"].exists)
    }
}

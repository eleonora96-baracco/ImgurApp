import XCTest

class ContentViewUITests: XCTestCase {
    
    var app: XCUIApplication!
    
    override func setUp() {
        super.setUp()
        
        // Initialize the app
        app = XCUIApplication()
        
        // Continue after failure
        continueAfterFailure = false
        
        // Launch the app with an empty access token to simulate the user not being logged in
        app.launchArguments = ["-UITest_NoAccessToken"]
        app.launch()
    }
    
    func testShowsLoginViewWhenNoAccessToken() {
        // Ensure we're on the login screen
        XCTAssertTrue(app.staticTexts["LoginViewTitle"].exists, "Login view title should exist.")
        
        // Verify the login button exists
        XCTAssertTrue(app.buttons["LoginButton"].exists, "Login button should exist.")
    }
}

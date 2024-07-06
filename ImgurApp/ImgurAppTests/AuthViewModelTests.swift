import XCTest
import SwiftUI
@testable import ImgurApp

class AuthViewModelTests: XCTestCase {
    
    var authenticationServiceMock: AuthenticationServiceProtocolMock!
    var sut: AuthViewModel!

    override func setUp() {
        super.setUp()
        authenticationServiceMock = AuthenticationServiceProtocolMock()
        sut = AuthViewModel(authenticationService: authenticationServiceMock)
    }

    override func tearDown() {
        authenticationServiceMock = nil
        sut = nil
        super.tearDown()
    }

    func testInit_WhenAuthenticated() {
        authenticationServiceMock.underlyingIsLoggedIn = true
        authenticationServiceMock.underlyingAccessToken = "test_token"
        sut = AuthViewModel(authenticationService: authenticationServiceMock)
        XCTAssertTrue(sut.isLoggedIn)
        XCTAssertEqual(sut.accessToken, "test_token")
    }

    func testInit_WhenNotAuthenticated() {
        authenticationServiceMock.underlyingIsLoggedIn = false
        authenticationServiceMock.underlyingAccessToken = nil
        sut = AuthViewModel(authenticationService: authenticationServiceMock)
        XCTAssertFalse(sut.isLoggedIn)
        XCTAssertNil(sut.accessToken)
    }

    func testStartOAuthFlow() {
        let testURL = URL(string: "https://example.com")!
        authenticationServiceMock.startOAuthFlowReturnValue = testURL
        let url = sut.startOAuthFlow()
        XCTAssertEqual(url, testURL)
    }

    func testHandleOAuthCallback_Success() {
        let expectation = self.expectation(description: "OAuth callback should succeed")
        let testURL = URL(string: "https://example.com")!
        let testToken = "test_token"

        authenticationServiceMock.handleOAuthCallbackUrlCompletionClosure = { _, completion in
            completion(.success(testToken))
        }

        sut.handleOAuthCallback(url: testURL)
        
        DispatchQueue.main.async {
            XCTAssertTrue(self.sut.isLoggedIn)
            XCTAssertEqual(self.sut.accessToken, testToken)
            XCTAssertNil(self.sut.errorMessage)
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1, handler: nil)
    }

    func testHandleOAuthCallback_Failure() {
        let expectation = self.expectation(description: "OAuth callback should fail")
        let testURL = URL(string: "https://example.com")!
        let testError = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to handle OAuth callback"])

        authenticationServiceMock.handleOAuthCallbackUrlCompletionClosure = { _, completion in
            completion(.failure(testError))
        }

        sut.handleOAuthCallback(url: testURL)
        
        DispatchQueue.main.async {
            XCTAssertFalse(self.sut.isLoggedIn)
            XCTAssertNil(self.sut.accessToken)
            XCTAssertEqual(self.sut.errorMessage?.message, "Failed to handle OAuth callback")
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1, handler: nil)
    }

    func testLogout() {
        sut.logout()
        XCTAssertFalse(sut.isLoggedIn)
        XCTAssertNil(sut.accessToken)
        XCTAssertTrue(authenticationServiceMock.logoutCalled)
    }
}

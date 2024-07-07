import XCTest
@testable import ImgurApp


class ImgurAuthenticationServiceInteractorTests: XCTestCase {
    var keychainHelperMock: KeychainHelperProtocolMock!
    var sut: ImgurAuthenticationServiceInteractor!
    
    override func setUp() {
        super.setUp()
        keychainHelperMock = KeychainHelperProtocolMock()
        sut = ImgurAuthenticationServiceInteractor(keychainHelper: keychainHelperMock)
    }
    
    override func tearDown() {
        keychainHelperMock = nil
        sut = nil
        super.tearDown()
    }
    
    func testIsLoggedIn_WhenAccessTokenExists_ShouldReturnTrue() {
        // Given
        keychainHelperMock.getForKeyReturnValue = "mockAccessToken"
        
        // When
        let isLoggedIn = sut.isLoggedIn
        
        // Then
        XCTAssertTrue(isLoggedIn)
    }
    
    func testIsLoggedIn_WhenAccessTokenDoesNotExist_ShouldReturnFalse() {
        // Given
        keychainHelperMock.getForKeyReturnValue = nil
        
        // When
        let isLoggedIn = sut.isLoggedIn
        
        // Then
        XCTAssertFalse(isLoggedIn)
    }
    
    func testStartOAuthFlow_ShouldReturnCorrectURL() {
        // Given
        let expectedURLString = "https://api.imgur.com/oauth2/authorize?client_id=2074a13d9af00d6&response_type=token&state=APPLICATION_STATE"
        
        // When
        let authURL = sut.startOAuthFlow()
        
        // Then
        XCTAssertEqual(authURL.absoluteString, expectedURLString)
    }
    
    func testHandleOAuthCallback_WhenAccessTokenIsPresent_ShouldSaveAccessToken() {
        // Given
        let testURL = URL(string: "imgur://callback#access_token=mockAccessToken&expires_in=3600")!
        let expectation = self.expectation(description: "Completion handler called")
        
        // When
        sut.handleOAuthCallback(url: testURL) { result in
            switch result {
            case .success(let token):
                XCTAssertEqual(token, "mockAccessToken")
            case .failure:
                XCTFail("Expected success but got failure")
            }
            expectation.fulfill()
        }
        
        // Then
        waitForExpectations(timeout: 1, handler: nil)
        XCTAssertEqual(keychainHelperMock.saveForKeyReceivedArguments?.value, "mockAccessToken")
    }
    
    func testHandleOAuthCallback_WhenAccessTokenIsNotPresent_ShouldReturnError() {
        // Given
        let testURL = URL(string: "imgur://callback#expires_in=3600")!
        let expectation = self.expectation(description: "Completion handler called")
        
        // When
        sut.handleOAuthCallback(url: testURL) { result in
            switch result {
            case .success:
                XCTFail("Expected failure but got success")
            case .failure(let error):
                XCTAssertNotNil(error.localizedDescription)
            }
            expectation.fulfill()
        }
        
        // Then
        waitForExpectations(timeout: 1, handler: nil)
    }

    func testLogoutSuccess() {
         keychainHelperMock.removeForKeyReturnValue = .success(())

         let expectation = self.expectation(description: "Completion handler called")
         sut.logout { error in
             XCTAssertNil(error, "Expected no error on success")
             expectation.fulfill()
         }

         waitForExpectations(timeout: 1, handler: nil)
         XCTAssertEqual(keychainHelperMock.removeForKeyCallsCount, 1, "Expected remove to be called once")
     }

     func testLogoutFailure() {
         let expectedError = IdentifiableError(message: "Test Error")
         keychainHelperMock.removeForKeyReturnValue = .failure(expectedError)

         let expectation = self.expectation(description: "Completion handler called")
         sut.logout { error in
             XCTAssertEqual(error?.message, expectedError.message, "Expected error message to match")
             expectation.fulfill()
         }

         waitForExpectations(timeout: 1, handler: nil)
         XCTAssertEqual(keychainHelperMock.removeForKeyCallsCount, 1, "Expected remove to be called once")
     }
}

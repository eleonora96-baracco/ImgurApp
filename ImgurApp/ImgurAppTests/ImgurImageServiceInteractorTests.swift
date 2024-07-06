import XCTest
@testable import ImgurApp

class ImgurImageFetchingServiceInteractorTests: XCTestCase {
    var mockSession: NetworkSessionProtocolMock!
    var sut: ImgurImageFetchingServiceInteractor!
    var dataTaskMock: NetworkDataTaskProtocolMock!
    
    override func setUp() {
        super.setUp()
        mockSession = NetworkSessionProtocolMock()
        sut = ImgurImageFetchingServiceInteractor(session: mockSession)
        dataTaskMock = NetworkDataTaskProtocolMock()
        mockSession.dataTaskWithRequestCompletionHandlerReturnValue = dataTaskMock
    }
    
    override func tearDown() {
        mockSession = nil
        dataTaskMock = nil 
        sut = nil
        super.tearDown()
    }
    
    func testFetchPhotosSuccess() {
        let testAccessToken = "test_access_token"
        let imgurResponse = ImgurImageMocks.makeimgurImageResponse()
        let data = try! JSONEncoder().encode(imgurResponse)
        mockSession.dataTaskWithRequestCompletionHandlerReturnValue = dataTaskMock
        mockSession.dataTaskWithRequestCompletionHandlerClosure = { _, completionHandler in
            completionHandler(data, self.makeHTTPURLResponse(statusCode: 200), nil)
            return self.dataTaskMock
        }
                
        let expectation = self.expectation(description: "Fetch photos")
        
        sut.fetchPhotos(accessToken: testAccessToken) { result in
            switch result {
            case .success(let images):
                XCTAssertEqual(images.count, 2)
                XCTAssertEqual(images[0].id, "1")
                XCTAssertEqual(images[1].id, "2")
            case .failure(let error):
                XCTFail("Expected success but got failure with error: \(error)")
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1, handler: nil)
        XCTAssertTrue(dataTaskMock.resumeCalled)
    }
    
    func testFetchPhoto_Failure_NoAccessToken() {
        let expectation = self.expectation(description: "Fetch photo should fail with no access token")
        sut.fetchPhotos(accessToken: nil) { result in
            switch result {
            case .success:
                XCTFail("Expected failure but got success")
            case .failure(let error):
                XCTAssertEqual((error as? IdentifiableError)?.message, "No access token provided")
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1, handler: nil)
    }

    
    func testFetchPhotos_Failure_NoData() {
        let testAccessToken = "test_access_token"
        
        mockSession.dataTaskWithRequestCompletionHandlerReturnValue = dataTaskMock
        mockSession.dataTaskWithRequestCompletionHandlerClosure = { _, completionHandler in
            completionHandler(nil, self.makeHTTPURLResponse(statusCode: 200), nil)
            return self.dataTaskMock
        }
        
        sut.fetchPhotos(accessToken: testAccessToken) { result in
            switch result {
            case .success:
                XCTFail("Expected failure but got success")
            case .failure(let error):
                XCTAssertEqual((error as? IdentifiableError)?.message, "No data received")
            }
        }
    }
        
    func testUploadPhoto_Success() {
        let expectation = self.expectation(description: "Upload photo should succeed")
        let testAccessToken = "test_access_token"
        let testImageData = Data(count: 10)
        let testData = try! JSONEncoder().encode(ImgurImageMocks.makeimgurImageUploadResponse())
        
        mockSession.dataTaskWithRequestCompletionHandlerReturnValue = dataTaskMock
        mockSession.dataTaskWithRequestCompletionHandlerClosure = { _, completionHandler in
            completionHandler(testData, self.makeHTTPURLResponse(statusCode: 200), nil)
            return self.dataTaskMock
        }

        sut.uploadPhoto(accessToken: testAccessToken, imageData: testImageData) { result in
            switch result {
            case .success(let image):
                XCTAssertEqual(image.id, "1")
                XCTAssertEqual(image.title, "Mock Image")
                XCTAssertEqual(image.link, "https://mocklink.com")
                XCTAssertEqual(image.description, "Mock Description")
            case .failure(let error):
                XCTFail("Expected success but got failure with error: \(error)")
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1, handler: nil)
        XCTAssertTrue(dataTaskMock.resumeCalled)
    }
    
    func testUploadPhoto_Failure_NoAccessToken() {
        let expectation = self.expectation(description: "Delete photo should fail with no access token")
        let testImageData = Data(count: 10)
        sut.uploadPhoto(accessToken: nil, imageData: testImageData) { result in
            switch result {
            case .success:
                XCTFail("Expected failure but got success")
            case .failure(let error):
                XCTAssertEqual((error as? IdentifiableError)?.message, "No access token provided")
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1, handler: nil)
    }

    
    func testUploadFoto_Failure_NoData() {
        let testAccessToken = "test_access_token"
        
        mockSession.dataTaskWithRequestCompletionHandlerReturnValue = dataTaskMock
        mockSession.dataTaskWithRequestCompletionHandlerClosure = { _, completionHandler in
            completionHandler(nil, self.makeHTTPURLResponse(statusCode: 200), nil)
            return self.dataTaskMock
        }
        
        sut.uploadPhoto(accessToken: testAccessToken, imageData: nil) { result in
            switch result {
            case .success:
                XCTFail("Expected failure but got success")
            case .failure(let error):
                XCTAssertEqual((error as? IdentifiableError)?.message, "No data received")
            }
        }
    }
    
        
    func testDeletePhotoSuccess() {
        let expectation = self.expectation(description: "Delete photo should succeed")
        let testAccessToken = "test_access_token"
        let testPhotoId = "test_photo_id"
        
        mockSession.dataTaskWithRequestCompletionHandlerReturnValue = dataTaskMock
        mockSession.dataTaskWithRequestCompletionHandlerClosure = { _, completionHandler in
            completionHandler(nil, self.makeHTTPURLResponse(statusCode: 200), nil)
            return self.dataTaskMock
        }
        
        sut.deletePhoto(accessToken: testAccessToken, photoId: testPhotoId) { result in
            switch result {
            case .success:
                // Success case does not return any data
                break
            case .failure(let error):
                XCTFail("Expected success but got failure with error: \(error)")
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1, handler: nil)
        XCTAssertTrue(dataTaskMock.resumeCalled)
    }
    
    func testDeletePhoto_Failure_NoAccessToken() {
        let expectation = self.expectation(description: "Delete photo should fail with no access token")
        sut.deletePhoto(accessToken: nil, photoId: "test_photo_id") { result in
            switch result {
            case .success:
                XCTFail("Expected failure but got success")
            case .failure(let error):
                XCTAssertEqual((error as? IdentifiableError)?.message, "No access token provided")
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1, handler: nil)
    }
}

extension ImgurImageFetchingServiceInteractorTests {
    private func makeHTTPURLResponse(statusCode: Int) -> HTTPURLResponse? {
        return HTTPURLResponse(
            url: URL(string: "https://api.imgur.com")!,
            statusCode: statusCode,
            httpVersion: nil,
            headerFields: nil
        )
    }
}
    


import XCTest
import SwiftUI
@testable import ImgurApp

class PhotoGalleryViewModelTests: XCTestCase {

    var imageFetchingServiceMock: ImageFetchingServiceProtocolMock!
    var viewModel: PhotoGalleryViewModel!

    override func setUp() {
        super.setUp()
        imageFetchingServiceMock = ImageFetchingServiceProtocolMock()
        viewModel = PhotoGalleryViewModel(imageFetchingServiceInteractor: imageFetchingServiceMock)
        viewModel.accessToken = "test_token"
    }

    override func tearDown() {
        imageFetchingServiceMock = nil
        viewModel = nil
        super.tearDown()
    }

    func testFetchPhotos_Success() {
        let expectation = self.expectation(description: "Fetching photos should succeed")
        let testImages = [ImgurImage(id: "test_id1", link: "test_link1", title: "test_title1", description: "desc1"),
                          ImgurImage(id: "test_id2", link: "test_link2", title: "test_title2", description: "desc2")]

        imageFetchingServiceMock.fetchPhotosAccessTokenCompletionClosure = { _, completion in
            completion(.success(testImages))
        }

        viewModel.fetchPhotos()
        
        DispatchQueue.main.async {
            XCTAssertEqual(self.viewModel.photos.count, testImages.count)
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1, handler: nil)
    }

    func testFetchPhotos_Failure() {
        let expectation = self.expectation(description: "Fetching photos should fail")
        let testError = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to fetch photos"])

        imageFetchingServiceMock.fetchPhotosAccessTokenCompletionClosure = { _, completion in
            completion(.failure(testError))
        }

        viewModel.fetchPhotos()
        
        DispatchQueue.main.async {
            XCTAssertEqual(self.viewModel.errorMessage?.message, "An unknown error occurred")
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func testAddPhoto() {
        let expectation = self.expectation(description: "Photo should be added")
        let testImgurImage = ImgurImage(id: "test_id", link: "test_link", title: "test_title", description: "desc")

        viewModel.addPhoto(testImgurImage)
        
        DispatchQueue.main.async {
            XCTAssertEqual(self.viewModel.photos.count, 1)
            XCTAssertEqual(self.viewModel.photos.first?.id, testImgurImage.id)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func testRemovePhoto_Success() {
        let expectation = self.expectation(description: "Photo removal should succeed")
        let testImgurImage = ImgurImage(id: "test_id", link: "test_link", title: "test_title", description: "desc")
        viewModel.photos = [testImgurImage]

        imageFetchingServiceMock.deletePhotoAccessTokenPhotoIdCompletionClosure = { _, _, completion in
            completion(.success(()))
        }

        viewModel.removePhoto(at: 0)

        DispatchQueue.main.async {
            XCTAssertEqual(self.viewModel.photos.count, 0)
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1, handler: nil)
    }

    func testRemovePhoto_Failure() {
        let expectation = self.expectation(description: "Photo removal should fail")
        let testImgurImage = ImgurImage(id: "test_id", link: "test_link", title: "test_title", description: "desc")
        viewModel.photos = [testImgurImage]

        let testError = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to delete photo"])

        imageFetchingServiceMock.deletePhotoAccessTokenPhotoIdCompletionClosure = { _, _, completion in
            completion(.failure(testError))
        }

        viewModel.removePhoto(at: 0)

        DispatchQueue.main.async {
            XCTAssertEqual(self.viewModel.photos.count, 1)
            XCTAssertEqual(self.viewModel.errorMessage?.message, "An unknown error occurred")
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1, handler: nil)
    }
}

import XCTest
import SwiftUI
@testable import ImgurApp

class ImagePickerViewModelTests: XCTestCase {
    
    var imageFetchingServiceMock: ImageFetchingServiceProtocolMock!
    var viewModel: ImagePickerViewModel!

    override func setUp() {
        super.setUp()
        imageFetchingServiceMock = ImageFetchingServiceProtocolMock()
        viewModel = ImagePickerViewModel(imageFetchingService: imageFetchingServiceMock)
    }

    override func tearDown() {
        imageFetchingServiceMock = nil
        viewModel = nil
        super.tearDown()
    }

    func testUploadImage_Success() {
        let expectation = self.expectation(description: "Image upload should succeed")
        let testImage = UIImage(systemName: "photo")!
        viewModel.selectedImage = testImage

        let testImgurImage = ImgurImage(id: "test_id", link: "test_link", title: "test_title", description: "desc")

        imageFetchingServiceMock.uploadPhotoAccessTokenImageDataCompletionClosure = { _, _, completion in
            completion(.success(testImgurImage))
        }
        let accessToken = "test_token"

        viewModel.uploadImage(accessToken: accessToken) { result in
            switch result {
            case .success(let imgurImage):
                XCTAssertEqual(imgurImage.id, testImgurImage.id)
                expectation.fulfill()
            case .failure:
                XCTFail("Expected success but got failure")
            }
        }

        waitForExpectations(timeout: 1, handler: nil)
    }

    func testUploadImage_NoSelectedImage() {
        let expectation = self.expectation(description: "Image upload should fail due to no selected image")
        let accessToken = "test_token"

        viewModel.uploadImage(accessToken: accessToken) { result in
            switch result {
            case .success:
                XCTFail("Expected failure but got success")
            case .failure(let error):
                XCTAssertEqual(error.message, "No image selected")
                expectation.fulfill()
            }
        }

        waitForExpectations(timeout: 1, handler: nil)
    }

    func testSelectImageFromFile_Success() {
        let imageData = UIImage(systemName: "photo")!.pngData()
        viewModel.selectImageFromFile(imageData)
        XCTAssertNotNil(viewModel.selectedImage)
    }

    func testSelectImageFromFile_Failure() {
        viewModel.selectImageFromFile(nil)
        XCTAssertNil(viewModel.selectedImage)
    }
}


import SwiftUI
import UIKit

class ImagePickerViewModel: ObservableObject {
    @Published var selectedImage: UIImage?
    @Published var errorMessage: IdentifiableError?

    private let imageFetchingService: ImageFetchingServiceProtocol

    init(imageFetchingService: ImageFetchingServiceProtocol) {
        self.imageFetchingService = imageFetchingService

    }

    func uploadImage(accessToken: String?, completion: @escaping (Result<ImgurImage, IdentifiableError>) -> Void) {
        guard let selectedImage = selectedImage else {
            let error = IdentifiableError(message: "No image selected")
            errorMessage = error
            completion(.failure(error))
            return
        }

        guard let imageData = selectedImage.jpegData(compressionQuality: 0.8) else {
            let error = IdentifiableError(message: "Failed to convert image to data")
            errorMessage = error
            completion(.failure(error))
            return
        }

        imageFetchingService.uploadPhoto(accessToken: accessToken, imageData: imageData) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let imgurImage):
                    completion(.success(imgurImage))
                case .failure(let error as IdentifiableError):
                    self.errorMessage = error
                    completion(.failure(error))
                default:
                    let error = IdentifiableError(message: "Unknown error")
                    self.errorMessage = error
                    completion(.failure(error))
                }
            }
        }
    }

    func selectImageFromCamera(_ image: UIImage) {
        selectedImage = image
    }

    func selectImageFromFile(_ data: Data?) {
        guard let data = data else {
            errorMessage = IdentifiableError(message: "No data provided")
            return
        }
        if let image = UIImage(data: data) {
            selectedImage = image
        } else {
            errorMessage = IdentifiableError(message: "Failed to convert data to image")
        }
    }
}

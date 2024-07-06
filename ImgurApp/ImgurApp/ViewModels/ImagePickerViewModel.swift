import SwiftUI
import UIKit

class ImagePickerViewModel: ObservableObject {
    @Published var selectedImage: UIImage?
    @Published var errorMessage: IdentifiableError?

    private let imageFetchingService: ImageFetchingServiceProtocol
    private let accessToken: String?

    init(imageFetchingService: ImageFetchingServiceProtocol, accessToken: String?) {
        self.imageFetchingService = imageFetchingService
        self.accessToken = accessToken
    }

    func uploadImage(completion: @escaping (Result<ImgurImage, IdentifiableError>) -> Void) {
        guard let selectedImage = selectedImage, let accessToken = accessToken else {
            completion(.failure(IdentifiableError(message: "No image selected or user not authenticated")))
            return
        }

        guard let imageData = selectedImage.jpegData(compressionQuality: 0.8) else {
            completion(.failure(IdentifiableError(message: "Failed to convert image to data")))
            return
        }

        imageFetchingService.uploadPhoto(accessToken: accessToken, imageData: imageData) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let imgurImage):
                    completion(.success(imgurImage))
                case .failure(let error):
                    self.errorMessage = IdentifiableError(message: error.localizedDescription)
                    completion(.failure(IdentifiableError(message: error.localizedDescription)))
                }
            }
        }
    }

    func selectImageFromCamera(_ image: UIImage) {
        selectedImage = image
    }

    func selectImageFromFile(_ data: Data?) {
        guard let data else { return }
        if let image = UIImage(data: data) {
            selectedImage = image
        } else {
            errorMessage = IdentifiableError(message: "Failed to convert data to image")
        }
    }
}

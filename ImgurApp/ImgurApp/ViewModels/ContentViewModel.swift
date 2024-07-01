import SwiftUI
import UIKit

class ContentViewModel: ObservableObject {
    @Published var selectedImage: UIImage?
    @Published var selectedImage1: Data?
    @Published var errorMessage: IdentifiableError?

    private let imageFetchingService: ImageFetchingServiceProtocol
    private let accessToken: String?

    init(imageFetchingService: ImageFetchingServiceProtocol, accessToken: String?) {
        self.imageFetchingService = imageFetchingService
        self.accessToken = accessToken
    }

    func uploadImage(completion: @escaping (Result<ImgurImage, IdentifiableError>) -> Void) {
//        guard let selectedImage = selectedImage, let accessToken = accessToken else {
//            completion(.failure(IdentifiableError(message: "No image selected or user not authenticated")))
//            return
//        }
        
        guard let selectedImage1 = selectedImage1 else {
            completion(.failure(IdentifiableError(message: "No image selected or user not authenticated")))
            return
        }
        
        let image = UIImage(data: selectedImage1)

        guard let imageData = image!.jpegData(compressionQuality: 0.8) else {
            completion(.failure(IdentifiableError(message: "Failed to convert image to data")))
            return
        }
        

        imageFetchingService.uploadPhoto(accessToken: accessToken!, imageData: imageData) { result in
            DispatchQueue.main.async {
                switch result {
                    case .success(let imgurImage):
                        completion(.success(imgurImage))
                    case .failure(let error):
                        completion(.failure(IdentifiableError(message: error.localizedDescription)))
                }
            }
        }
    }

    func handleFileImport(result: Result<[URL], Error>) {
        switch result {
            case .success(let urls):
                if let url = urls.first, let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                    self.selectedImage = image
                } else {
                    self.errorMessage = IdentifiableError(message: "Failed to load image from file")
                }
            case .failure(let error):
                self.errorMessage = IdentifiableError(message: error.localizedDescription)
        }
    }
}

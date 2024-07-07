import SwiftUI

class PhotoGalleryViewModel: ObservableObject {
    @Published var photos: [ImgurImage] = []
    @Published var errorMessage: IdentifiableError?
    
    private let imageFetchingServiceInteractor: ImageFetchingServiceProtocol
    @Published var accessToken: String?

    init(imageFetchingServiceInteractor: ImageFetchingServiceProtocol) {
        self.imageFetchingServiceInteractor = imageFetchingServiceInteractor
    }
    
    func fetchPhotos() {
        imageFetchingServiceInteractor.fetchPhotos(accessToken: accessToken) {  result in
            DispatchQueue.main.async {
                switch result {
                case .success(let images):
                    self.photos = images
                case .failure(let error as IdentifiableError):
                    self.errorMessage = error
                default:
                    self.errorMessage = IdentifiableError(message: "An unknown error occurred")
                }
            }
        }
    }

    func addPhoto(_ imgurImage: ImgurImage) {
        DispatchQueue.main.async {
            self.photos.append(imgurImage)
        }
    }

    func removePhoto(at index: Int) {
        guard index < photos.count else { return }
        let photo = photos[index]
        imageFetchingServiceInteractor.deletePhoto(accessToken: accessToken, photoId: photo.id) { result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self.photos.remove(at: index)
                case .failure(let error as IdentifiableError):
                    self.errorMessage = error
                default:
                    self.errorMessage = IdentifiableError(message: "An unknown error occurred")
                }
            }
        }
    }
}


import SwiftUI

class PhotoGalleryViewModel: ObservableObject {
    @Published var photos: [ImgurImage] = []
    @Published var errorMessage: IdentifiableError?
    
    private let imageFetchingServiceInteractor: ImageFetchingServiceProtocol
    private var accessToken: String?

    init(imageFetchingServiceInteractor: ImageFetchingServiceProtocol, accessToken: String?) {
        self.imageFetchingServiceInteractor = imageFetchingServiceInteractor
        self.accessToken = accessToken
        fetchPhotos()
    }

    func fetchPhotos() {
        guard let token = accessToken else { return }
        imageFetchingServiceInteractor.fetchPhotos(accessToken: token) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let images):
                    self?.photos = images
                case .failure(let error):
                    self?.errorMessage = IdentifiableError(message: error.localizedDescription)
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
        guard photos.indices.contains(index) else { return }
        DispatchQueue.main.async {
            self.photos.remove(at: index)
        }
    }
}


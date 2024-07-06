import Foundation


class ImageFetchingServiceProtocolMock: ImageFetchingServiceProtocol {

    // MARK: - fetchPhotos

    var fetchPhotosAccessTokenCompletionCallsCount = 0
    var fetchPhotosAccessTokenCompletionCalled: Bool {
        return fetchPhotosAccessTokenCompletionCallsCount > 0
    }
    var fetchPhotosAccessTokenCompletionReceivedArguments: (accessToken: String?, completion: (Result<[ImgurImage], Error>) -> Void)?
    var fetchPhotosAccessTokenCompletionReceivedInvocations: [(accessToken: String?, completion: (Result<[ImgurImage], Error>) -> Void)] = []
    var fetchPhotosAccessTokenCompletionClosure: ((String, @escaping (Result<[ImgurImage], Error>) -> Void) -> Void)?

    func fetchPhotos(accessToken: String?, completion: @escaping (Result<[ImgurImage], Error>) -> Void) {
        fetchPhotosAccessTokenCompletionCallsCount += 1
        fetchPhotosAccessTokenCompletionReceivedArguments = (accessToken: accessToken, completion: completion)
        fetchPhotosAccessTokenCompletionReceivedInvocations.append((accessToken: accessToken, completion: completion))
        fetchPhotosAccessTokenCompletionClosure?(accessToken ?? "", completion)
    }

    // MARK: - uploadPhoto

    var uploadPhotoAccessTokenImageDataCompletionCallsCount = 0
    var uploadPhotoAccessTokenImageDataCompletionCalled: Bool {
        return uploadPhotoAccessTokenImageDataCompletionCallsCount > 0
    }
    var uploadPhotoAccessTokenImageDataCompletionReceivedArguments: (accessToken: String?, imageData: Data?, completion: (Result<ImgurImage, Error>) -> Void)?
    var uploadPhotoAccessTokenImageDataCompletionReceivedInvocations: [(accessToken: String?, imageData: Data?, completion: (Result<ImgurImage, Error>) -> Void)] = []
    var uploadPhotoAccessTokenImageDataCompletionClosure: ((String?, Data?, @escaping (Result<ImgurImage, Error>) -> Void) -> Void)?

    func uploadPhoto(accessToken: String?, imageData: Data?, completion: @escaping (Result<ImgurImage, Error>) -> Void) {
        uploadPhotoAccessTokenImageDataCompletionCallsCount += 1
        uploadPhotoAccessTokenImageDataCompletionReceivedArguments = (accessToken: accessToken, imageData: imageData, completion: completion)
        uploadPhotoAccessTokenImageDataCompletionReceivedInvocations.append((accessToken: accessToken, imageData: imageData, completion: completion))
        uploadPhotoAccessTokenImageDataCompletionClosure?(accessToken, imageData, completion)
    }

    // MARK: - deletePhoto

    var deletePhotoAccessTokenPhotoIdCompletionCallsCount = 0
    var deletePhotoAccessTokenPhotoIdCompletionCalled: Bool {
        return deletePhotoAccessTokenPhotoIdCompletionCallsCount > 0
    }
    var deletePhotoAccessTokenPhotoIdCompletionReceivedArguments: (accessToken: String?, photoId: String, completion: (Result<Void, Error>) -> Void)?
    var deletePhotoAccessTokenPhotoIdCompletionReceivedInvocations: [(accessToken: String?, photoId: String, completion: (Result<Void, Error>) -> Void)] = []
    var deletePhotoAccessTokenPhotoIdCompletionClosure: ((String?, String, @escaping (Result<Void, Error>) -> Void) -> Void)?

    func deletePhoto(accessToken: String?, photoId: String, completion: @escaping (Result<Void, Error>) -> Void) {
        deletePhotoAccessTokenPhotoIdCompletionCallsCount += 1
        deletePhotoAccessTokenPhotoIdCompletionReceivedArguments = (accessToken: accessToken, photoId: photoId, completion: completion)
        deletePhotoAccessTokenPhotoIdCompletionReceivedInvocations.append((accessToken: accessToken, photoId: photoId, completion: completion))
        deletePhotoAccessTokenPhotoIdCompletionClosure?(accessToken, photoId, completion)
    }
}

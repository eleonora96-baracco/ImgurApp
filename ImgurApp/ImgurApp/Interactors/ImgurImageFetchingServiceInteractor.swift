import Foundation

protocol ImageFetchingServiceProtocol {
    func fetchPhotos(accessToken: String, completion: @escaping (Result<[ImgurImage], Error>) -> Void)
}

class ImgurImageFetchingServiceInteractor: ImageFetchingServiceProtocol {
    func fetchPhotos(accessToken: String, completion: @escaping (Result<[ImgurImage], Error>) -> Void) {
        let url = URL(string: "https://api.imgur.com/3/account/me/images")!
        var request = URLRequest(url: url)
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }

            guard let data = data else {
                DispatchQueue.main.async {
                    completion(.failure(NSError(domain: "ImgurImageFetchingService", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                }
                return
            }

            do {
                let response = try JSONDecoder().decode(ImgurImageResponse.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(response.data))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }.resume()
    }
}


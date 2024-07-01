import Foundation

protocol ImageFetchingServiceProtocol {
    func fetchPhotos(accessToken: String, completion: @escaping (Result<[ImgurImage], Error>) -> Void)
    func uploadPhoto(accessToken: String, imageData: Data, completion: @escaping (Result<ImgurImage, Error>) -> Void)
}

class ImgurImageFetchingServiceInteractor: ImageFetchingServiceProtocol {
    func fetchPhotos(accessToken: String, completion: @escaping (Result<[ImgurImage], Error>) -> Void) {
        guard let url = URL(string: "https://api.imgur.com/3/account/me/images") else {
            completion(.failure(IdentifiableError(message: "Invalid URL")))
            return
        }

        var request = URLRequest(url: url)
        request.addValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(IdentifiableError(message: "No data received")))
                return
            }

            do {
                let imgurResponse = try JSONDecoder().decode(ImgurImageResponse.self, from: data)
                completion(.success(imgurResponse.data))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }

    func uploadPhoto(accessToken: String, imageData: Data, completion: @escaping (Result<ImgurImage, Error>) -> Void) {
        guard let url = URL(string: "https://api.imgur.com/3/image") else {
            completion(.failure(IdentifiableError(message: "Invalid URL")))
            return
        }

        var request = URLRequest(url: url)
        request.addValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "POST"
        request.httpBody = imageData
        request.setValue("multipart/form-data", forHTTPHeaderField: "Content-Type")

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(IdentifiableError(message: "No data received")))
                return
            }

            do {
                let imgurResponse = try JSONDecoder().decode(ImgurImageResponse.self, from: data)
                if let image = imgurResponse.data.first {
                    completion(.success(image))
                } else {
                    completion(.failure(IdentifiableError(message: "Image upload failed")))
                }
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}



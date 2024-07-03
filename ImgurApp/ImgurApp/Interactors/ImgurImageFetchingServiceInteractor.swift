import Foundation

protocol ImageFetchingServiceProtocol {
    func fetchPhotos(accessToken: String, completion: @escaping (Result<[ImgurImage], Error>) -> Void)
    func uploadPhoto(accessToken: String, imageData: Data, completion: @escaping (Result<ImgurImage, Error>) -> Void)
    func deletePhoto(accessToken: String?, photoId: String, completion: @escaping (Result<Void, Error>) -> Void)
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
        
        let boundary = UUID().uuidString
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        var body = Data()
        let lineBreak = "\r\n"
        
        // Add image data to body
        body.append("--\(boundary)\(lineBreak)")
        body.append("Content-Disposition: form-data; name=\"image\"; filename=\"image.jpg\"\(lineBreak)")
        body.append("Content-Type: image/jpeg\(lineBreak)\(lineBreak)")
        body.append(imageData)
        body.append(lineBreak)
        
        // Add type field to body
        body.append("--\(boundary)\(lineBreak)")
        body.append("Content-Disposition: form-data; name=\"type\"\(lineBreak)\(lineBreak)")
        body.append("image\(lineBreak)")
        
        // Add title field to body
        body.append("--\(boundary)\(lineBreak)")
        body.append("Content-Disposition: form-data; name=\"title\"\(lineBreak)\(lineBreak)")
        body.append("Simple upload\(lineBreak)")
        
        // Add description field to body
        body.append("--\(boundary)\(lineBreak)")
        body.append("Content-Disposition: form-data; name=\"description\"\(lineBreak)\(lineBreak)")
        body.append("This is a simple image upload in Imgur\(lineBreak)")
        
        // End of body
        body.append("--\(boundary)--\(lineBreak)")
        
        request.httpBody = body

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
                let imgurResponse = try JSONDecoder().decode(ImgurImageUploadResponse.self, from: data)
                if imgurResponse.success {
                    completion(.success(imgurResponse.data))
                } else {
                    completion(.failure(IdentifiableError(message: "Image upload failed with status: \(imgurResponse.status)")))
                }
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    func deletePhoto(accessToken: String?, photoId: String, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let accessToken = accessToken else {
            completion(.failure(IdentifiableError(message: "No access token provided")))
            return
        }

        guard let url = URL(string: "https://api.imgur.com/3/image/\(photoId)") else {
            completion(.failure(IdentifiableError(message: "Invalid URL")))
            return
        }

        var request = URLRequest(url: url)
        request.addValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "DELETE"

        URLSession.shared.dataTask(with: request) { _, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                completion(.failure(IdentifiableError(message: "Failed to delete photo")))
                return
            }

            completion(.success(()))
        }.resume()
    }
}


// Extension to append string data to Data
extension Data {
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
}

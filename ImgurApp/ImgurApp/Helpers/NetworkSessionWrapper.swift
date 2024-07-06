import Foundation

protocol NetworkDataTaskProtocol {
    func resume()
}

protocol NetworkSessionProtocol {
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> NetworkDataTaskProtocol
}

class NetworkDataTaskWrapper: NetworkDataTaskProtocol {
    private let wrapped: URLSessionDataTask

    init(wrapping task: URLSessionDataTask) {
        self.wrapped = task
    }

    func resume() {
        wrapped.resume()
    }
}

class NetworkSessionWrapper: NetworkSessionProtocol {
    private let urlSession: URLSession

    init(urlSession: URLSession = .shared) {
        self.urlSession = urlSession
    }

    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> NetworkDataTaskProtocol {
        let dataTask = urlSession.dataTask(with: request, completionHandler: completionHandler)
        return NetworkDataTaskWrapper(wrapping: dataTask)
    }
}

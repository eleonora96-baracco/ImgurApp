import Foundation

protocol AuthenticationServiceProtocol {
    var isLoggedIn: Bool { get }
    var accessToken: String? { get }
    
    func startOAuthFlow() -> URL
    func handleOAuthCallback(url: URL, completion: @escaping (Result<String, Error>) -> Void)
    func logout(completion: @escaping (IdentifiableError?) -> Void)
}

class ImgurAuthenticationServiceInteractor: AuthenticationServiceProtocol {
    private let clientId = "2074a13d9af00d6"
    private let authorizationEndpoint = "https://api.imgur.com/oauth2/authorize"
    private let keychainKey = "imgurAccessToken"
    
    private let keychainHelper: KeychainHelperProtocol
    
    var isLoggedIn: Bool {
        return accessToken != nil
    }
    
    var accessToken: String? {
        return keychainHelper.get(forKey: keychainKey)
    }
    
    init(keychainHelper: KeychainHelperProtocol = KeychainHelper.shared) {
        self.keychainHelper = keychainHelper
    }

    func startOAuthFlow() -> URL {
        let authURL = "\(authorizationEndpoint)?client_id=\(clientId)&response_type=token&state=APPLICATION_STATE"
        return URL(string: authURL)!
    }

    func handleOAuthCallback(url: URL, completion: @escaping (Result<String, Error>) -> Void) {
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
              let fragment = components.fragment else {
            completion(.failure(IdentifiableError(message: "An error occurred during the login. Please, retry!")))
            return
        }
        
        let params = fragment.split(separator: "&").reduce(into: [String: String]()) { result, part in
            let pair = part.split(separator: "=")
            if pair.count == 2 {
                result[String(pair[0])] = String(pair[1])
            }
        }
        
        if let accessToken = params["access_token"] {
            switch keychainHelper.save(accessToken, forKey: keychainKey) {
            case .success:
                completion(.success(accessToken))
            case .failure(let error):
                completion(.failure(error))
            }
            
        } else {
            completion(.failure(IdentifiableError(message: "Access token not found")))
        }
    }
    
    func logout(completion: @escaping (IdentifiableError?) -> Void) {
        switch keychainHelper.remove(forKey: keychainKey) {
        case .success:
            completion(nil)
        case .failure(let error):
            completion(error)
        }
    }
    
    // Internal property for testing
    internal var testKeychainKey: String {
        return keychainKey
    }
}

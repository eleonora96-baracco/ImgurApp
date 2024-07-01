import Foundation

protocol AuthenticationServiceProtocol {
    func startOAuthFlow() -> URL
    func handleOAuthCallback(url: URL) -> Result<Void, IdentifiableError>
    func logout()
}


class ImgurAuthenticationServiceInteractor: AuthenticationServiceProtocol {
    private let clientId = "YOUR_IMGUR_CLIENT_ID"
    private let authorizationEndpoint = "https://api.imgur.com/oauth2/authorize"
    private let redirectUri = "myapp://auth"
    private let keychainKey = "imgurAccessToken"

    var accessToken: String? {
        get {
            return KeychainHelper.shared.read(forKey: keychainKey)
        }
        set {
            if let newValue = newValue {
                KeychainHelper.shared.save(newValue, forKey: keychainKey)
            } else {
                KeychainHelper.shared.delete(forKey: keychainKey)
            }
        }
    }

    var isLoggedIn: Bool {
        return accessToken != nil
    }

    func startOAuthFlow() -> URL {
        let authURL = "\(authorizationEndpoint)?client_id=\(clientId)&response_type=token&state=APPLICATION_STATE&redirect_uri=\(redirectUri)"
        return URL(string: authURL)!
    }

    func handleOAuthCallback(url: URL) -> Result<Void, IdentifiableError> {
        guard let fragment = url.fragment else {
            return .failure(IdentifiableError(message: "Invalid URL"))
        }
        
        let params = fragment.split(separator: "&").reduce(into: [String: String]()) { result, param in
            let parts = param.split(separator: "=")
            if parts.count == 2 {
                result[String(parts[0])] = String(parts[1])
            }
        }
        
        if let token = params["access_token"] {
            self.accessToken = token
            return .success(())
        } else {
            return .failure(IdentifiableError(message: "No access token found"))
        }
    }

    func logout() {
        accessToken = nil
    }
}

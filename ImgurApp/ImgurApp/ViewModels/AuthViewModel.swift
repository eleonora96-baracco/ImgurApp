import SwiftUI

class AuthViewModel: ObservableObject {
    @Published var isLoggedIn = false
    @Published var errorMessage: IdentifiableError?
    
    private let authenticationService: AuthenticationServiceProtocol
    @Published private(set) var accessToken: String?

    init(authenticationService: AuthenticationServiceProtocol) {
        self.authenticationService = authenticationService
        self.isLoggedIn = authenticationService.isLoggedIn
        self.accessToken = authenticationService.accessToken
    }

    func startOAuthFlow() -> URL {
        return authenticationService.startOAuthFlow()
    }

    func handleOAuthCallback(url: URL) {
        authenticationService.handleOAuthCallback(url: url) { result in
            switch result {
                case .success(let token):
                    DispatchQueue.main.async {
                        self.isLoggedIn = true
                        self.accessToken = token
                        
                    }
                case .failure(let error as IdentifiableError):
                    DispatchQueue.main.async {
                        self.isLoggedIn = false
                        self.errorMessage = error
                    }
            default:
                DispatchQueue.main.async {
                    self.isLoggedIn = false
                    self.errorMessage = IdentifiableError(message: "An unknown error occurred")
                }
            }
        }
    }

    func logout() {
        authenticationService.logout { [weak self] error in
            DispatchQueue.main.async {
                if let error = error {
                    self?.errorMessage = error
                }
            }
        }
        self.isLoggedIn = false
        self.accessToken = nil
    }
}


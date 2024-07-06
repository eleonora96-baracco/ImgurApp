import Foundation

class AuthenticationServiceProtocolMock: AuthenticationServiceProtocol {
    // MARK: - isLoggedIn

    var isLoggedIn: Bool {
        get {
            return underlyingIsLoggedIn
        }
        set(value) {
            underlyingIsLoggedIn = value
        }
    }
    var underlyingIsLoggedIn: Bool = false

    // MARK: - accessToken

    var accessToken: String? {
        get {
            return underlyingAccessToken
        }
        set(value) {
            underlyingAccessToken = value
        }
    }
    var underlyingAccessToken: String?

    // MARK: - startOAuthFlow

    var startOAuthFlowCallsCount = 0
    var startOAuthFlowCalled: Bool {
        return startOAuthFlowCallsCount > 0
    }
    var startOAuthFlowReturnValue: URL!
    var startOAuthFlowClosure: (() -> URL)?

    func startOAuthFlow() -> URL {
        startOAuthFlowCallsCount += 1
        return startOAuthFlowClosure.map { $0() } ?? startOAuthFlowReturnValue
    }

    // MARK: - handleOAuthCallback

    var handleOAuthCallbackUrlCompletionCallsCount = 0
    var handleOAuthCallbackUrlCompletionCalled: Bool {
        return handleOAuthCallbackUrlCompletionCallsCount > 0
    }
    var handleOAuthCallbackUrlCompletionReceivedArguments: (url: URL, completion: (Result<String, Error>) -> Void)?
    var handleOAuthCallbackUrlCompletionReceivedInvocations: [(url: URL, completion: (Result<String, Error>) -> Void)] = []
    var handleOAuthCallbackUrlCompletionClosure: ((URL, @escaping (Result<String, Error>) -> Void) -> Void)?

    func handleOAuthCallback(url: URL, completion: @escaping (Result<String, Error>) -> Void) {
        handleOAuthCallbackUrlCompletionCallsCount += 1
        handleOAuthCallbackUrlCompletionReceivedArguments = (url: url, completion: completion)
        handleOAuthCallbackUrlCompletionReceivedInvocations.append((url: url, completion: completion))
        handleOAuthCallbackUrlCompletionClosure?(url, completion)
    }

    // MARK: - logout

    var logoutCallsCount = 0
    var logoutCalled: Bool {
        return logoutCallsCount > 0
    }
    var logoutClosure: (() -> Void)?

    func logout() {
        logoutCallsCount += 1
        logoutClosure?()
    }
}

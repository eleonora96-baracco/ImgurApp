import Foundation

class NetworkDataTaskProtocolMock: NetworkDataTaskProtocol {

    // MARK: - resume

    var resumeCallsCount = 0
    var resumeCalled: Bool {
        return resumeCallsCount > 0
    }
    var resumeClosure: (() -> Void)?

    func resume() {
        resumeCallsCount += 1
        resumeClosure?()
    }
}

class NetworkSessionProtocolMock: NetworkSessionProtocol {

    // MARK: - dataTask

    var dataTaskWithRequestCompletionHandlerCallsCount = 0
    var dataTaskWithRequestCompletionHandlerCalled: Bool {
        return dataTaskWithRequestCompletionHandlerCallsCount > 0
    }
    var dataTaskWithRequestCompletionHandlerReceivedArguments: (request: URLRequest, completionHandler: (Data?, URLResponse?, Error?) -> Void)?
    var dataTaskWithRequestCompletionHandlerReceivedInvocations: [(request: URLRequest, completionHandler: (Data?, URLResponse?, Error?) -> Void)] = []
    var dataTaskWithRequestCompletionHandlerReturnValue: NetworkDataTaskProtocol!
    var dataTaskWithRequestCompletionHandlerClosure: ((URLRequest, @escaping (Data?, URLResponse?, Error?) -> Void) -> NetworkDataTaskProtocol)?

    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> NetworkDataTaskProtocol {
        dataTaskWithRequestCompletionHandlerCallsCount += 1
        dataTaskWithRequestCompletionHandlerReceivedArguments = (request: request, completionHandler: completionHandler)
        dataTaskWithRequestCompletionHandlerReceivedInvocations.append((request: request, completionHandler: completionHandler))
        return dataTaskWithRequestCompletionHandlerClosure?(request, completionHandler) ?? dataTaskWithRequestCompletionHandlerReturnValue
    }
}


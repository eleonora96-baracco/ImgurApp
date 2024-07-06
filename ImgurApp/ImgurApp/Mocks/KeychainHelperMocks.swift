import Foundation

class KeychainHelperProtocolMock: KeychainHelperProtocol {

    // MARK: - save

    var saveForKeyCallsCount = 0
    var saveForKeyCalled: Bool {
        return saveForKeyCallsCount > 0
    }
    var saveForKeyReceivedArguments: (value: String, key: String)?
    var saveForKeyReceivedInvocations: [(value: String, key: String)] = []
    var saveForKeyClosure: ((String, String) -> Void)?

    func save(_ value: String, forKey key: String) {
        saveForKeyCallsCount += 1
        saveForKeyReceivedArguments = (value: value, key: key)
        saveForKeyReceivedInvocations.append((value: value, key: key))
        saveForKeyClosure?(value, key)
    }

    // MARK: - get

    var getForKeyCallsCount = 0
    var getForKeyCalled: Bool {
        return getForKeyCallsCount > 0
    }
    var getForKeyReceivedKey: String?
    var getForKeyReceivedInvocations: [String] = []
    var getForKeyReturnValue: String?
    var getForKeyClosure: ((String) -> String?)?

    func get(forKey key: String) -> String? {
        getForKeyCallsCount += 1
        getForKeyReceivedKey = key
        getForKeyReceivedInvocations.append(key)
        return getForKeyClosure?(key) ?? getForKeyReturnValue
    }

    // MARK: - remove

    var removeForKeyCallsCount = 0
    var removeForKeyCalled: Bool {
        return removeForKeyCallsCount > 0
    }
    var removeForKeyReceivedKey: String?
    var removeForKeyReceivedInvocations: [String] = []
    var removeForKeyClosure: ((String) -> Void)?

    func remove(forKey key: String) {
        removeForKeyCallsCount += 1
        removeForKeyReceivedKey = key
        removeForKeyReceivedInvocations.append(key)
        removeForKeyClosure?(key)
    }
}


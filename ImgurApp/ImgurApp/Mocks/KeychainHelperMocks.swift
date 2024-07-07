class KeychainHelperProtocolMock: KeychainHelperProtocol {

    // MARK: - save

    var saveForKeyCallsCount = 0
    var saveForKeyCalled: Bool {
        return saveForKeyCallsCount > 0
    }
    var saveForKeyReceivedArguments: (value: String, key: String)?
    var saveForKeyReceivedInvocations: [(value: String, key: String)] = []
    var saveForKeyClosure: ((String, String) -> Result<Void, IdentifiableError>)?
    var saveForKeyReturnValue: Result<Void, IdentifiableError> = .success(())

    func save(_ value: String, forKey key: String) -> Result<Void, IdentifiableError> {
        saveForKeyCallsCount += 1
        saveForKeyReceivedArguments = (value: value, key: key)
        saveForKeyReceivedInvocations.append((value: value, key: key))
        return saveForKeyClosure?(value, key) ?? saveForKeyReturnValue
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
    var removeForKeyClosure: ((String) -> Result<Void, IdentifiableError>)?
    var removeForKeyReturnValue: Result<Void, IdentifiableError> = .success(())

    func remove(forKey key: String) -> Result<Void, IdentifiableError> {
        removeForKeyCallsCount += 1
        removeForKeyReceivedKey = key
        removeForKeyReceivedInvocations.append(key)
        return removeForKeyClosure?(key) ?? removeForKeyReturnValue
    }
}

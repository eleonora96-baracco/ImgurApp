import Foundation
import Security

enum KeychainError: Error, Identifiable {
    case saveError(status: OSStatus)
    case retrieveError(status: OSStatus)
    case deleteError(status: OSStatus)
    case dataConversionError

    var id: String {
        switch self {
        case .saveError(let status):
            return "saveError-\(status)"
        case .retrieveError(let status):
            return "retrieveError-\(status)"
        case .deleteError(let status):
            return "deleteError-\(status)"
        case .dataConversionError:
            return "dataConversionError"
        }
    }

    var message: String {
        switch self {
        case .saveError(let status):
            return "Error saving to keychain: \(status)"
        case .retrieveError(let status):
            return "Error retrieving from keychain: \(status)"
        case .deleteError(let status):
            return "Error deleting from keychain: \(status)"
        case .dataConversionError:
            return "Failed to convert data"
        }
    }
}


protocol KeychainHelperProtocol {
    func save(_ value: String, forKey key: String) -> Result<Void, IdentifiableError>
    func get(forKey key: String) -> String?
    func remove(forKey key: String) -> Result<Void, IdentifiableError>
}

class KeychainHelper: KeychainHelperProtocol {
    static let shared = KeychainHelper()
    
    private init() {}

    func save(_ value: String, forKey key: String) -> Result<Void, IdentifiableError> {
        guard let data = value.data(using: .utf8) else {
            return .failure(IdentifiableError(message: KeychainError.dataConversionError.message))
        }

        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key,
            kSecValueData: data
        ] as CFDictionary

        SecItemDelete(query)
        let status = SecItemAdd(query, nil)
        if status == errSecSuccess {
            return .success(())
        } else {
            return .failure(IdentifiableError(message: KeychainError.saveError(status: status).message))
        }
    }

    func get(forKey key: String) -> String? {
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key,
            kSecReturnData: true,
            kSecMatchLimit: kSecMatchLimitOne
        ] as CFDictionary

        var dataTypeRef: AnyObject?
        let status = SecItemCopyMatching(query, &dataTypeRef)
        if status == errSecSuccess, let data = dataTypeRef as? Data, let value = String(data: data, encoding: .utf8) {
            return value
        } else {
            print("Error retrieving from keychain: \(status)")
            return nil
        }
    }

    func remove(forKey key: String) -> Result<Void, IdentifiableError> {
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key
        ] as CFDictionary

        let status = SecItemDelete(query)
        if status == errSecSuccess {
            return .success(())
        } else {
            return .failure(IdentifiableError(message: KeychainError.deleteError(status: status).message))
        }
    }
}

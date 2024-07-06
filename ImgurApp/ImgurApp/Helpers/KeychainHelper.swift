import Foundation
import Security

protocol KeychainHelperProtocol {
    func save(_ value: String, forKey key: String)
    func get(forKey key: String) -> String?
    func remove(forKey key: String)
}

class KeychainHelper: KeychainHelperProtocol {
    static let shared = KeychainHelper()
    
    private init() {}
    
    func save(_ value: String, forKey key: String) {
        guard let data = value.data(using: .utf8) else { return }

        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key,
            kSecValueData: data
        ] as CFDictionary

        SecItemDelete(query)
        let status = SecItemAdd(query, nil)
        if status != errSecSuccess {
            print("Error saving to keychain: \(status)")
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

    func remove(forKey key: String) {
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key
        ] as CFDictionary

        let status = SecItemDelete(query)
        if status != errSecSuccess {
            print("Error deleting from keychain: \(status)")
        }
    }
}

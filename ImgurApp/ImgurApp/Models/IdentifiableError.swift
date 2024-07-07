import Foundation

struct IdentifiableError: Identifiable, Error {
    let id = UUID()
    let message: String
    
    var errorMessage: String? {
        return message
    }
}


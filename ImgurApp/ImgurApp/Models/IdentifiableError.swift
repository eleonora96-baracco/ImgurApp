import Foundation

struct IdentifiableError: Identifiable, Error {
    let id = UUID()
    let message: String
}

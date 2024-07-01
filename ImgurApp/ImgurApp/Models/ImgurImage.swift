import Foundation

struct ImgurImage: Identifiable, Codable {
    let id: String
    let link: String
    let title: String?
    let description: String?
}

struct ImgurImageResponse: Codable {
    let data: [ImgurImage]
}

struct ImgurImageUploadResponse: Codable {
    let data: ImgurImage
    let success: Bool
    let status: Int
}

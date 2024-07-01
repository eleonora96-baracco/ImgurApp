import Foundation

struct ImgurImage: Identifiable, Codable {
    let id: String
    let title: String?
    let link: String
}

struct ImgurImageResponse: Codable {
    let data: [ImgurImage]
}


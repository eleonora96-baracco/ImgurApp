import Foundation

class ImgurImageMocks {
    
    static func makeimgurImage() -> ImgurImage {
        ImgurImage(id: "1",
                   link: "https://mocklink1.com",
                   title: "Mock Image 1",
                   description: "Mock Description 1")
    }

    static func makeimgurImageResponse() -> ImgurImageResponse {
        let defaultImages = [
            ImgurImage(id: "1", 
                       link: "https://mocklink1.com",
                       title: "Mock Image 1",
                       description: "Mock Description 1"),
            ImgurImage(id: "2", 
                       link: "https://mocklink2.com",
                       title: "Mock Image 2",
                       description: "Mock Description 2")
        ]
        return ImgurImageResponse(data: defaultImages)
    }

    static func makeimgurImageUploadResponse() -> ImgurImageUploadResponse {
        let defaultImage = ImgurImage(id: "1", 
                                      link: "https://mocklink.com",
                                      title: "Mock Image",
                                      description: "Mock Description")
        return ImgurImageUploadResponse(data: defaultImage, success: true, status: 200)
    }
}


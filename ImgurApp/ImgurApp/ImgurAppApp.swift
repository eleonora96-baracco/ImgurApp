import SwiftUI

@main
struct ImgurAppApp: App {
    var body: some Scene {
        WindowGroup {
            let authService = ImgurAuthenticationServiceInteractor()
            let imageFetchingService = ImgurImageFetchingServiceInteractor()
            let authViewModel = AuthViewModel(authenticationService: authService)
            let photoGalleryViewModel = PhotoGalleryViewModel(imageFetchingServiceInteractor: imageFetchingService)
            let imagePickerViewModel = ImagePickerViewModel(imageFetchingService: imageFetchingService)
            
            ContentView(authViewModel: authViewModel, photoGalleryViewModel: photoGalleryViewModel, imagePickerViewModel: imagePickerViewModel)
        }
    }
}

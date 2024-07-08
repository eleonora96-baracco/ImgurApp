import SwiftUI

@main
struct ImgurAppApp: App {
    @StateObject var authViewModel: AuthViewModel

    init() {
        let authService = ImgurAuthenticationServiceInteractor()
        let isUITest = ProcessInfo.processInfo.arguments.contains("-UITest_NoAccessToken")
        if isUITest {
            // Clear the access token for UI testing
            UserDefaults.standard.removeObject(forKey: "imgurAccessToken")
        }
        _authViewModel = StateObject(wrappedValue: AuthViewModel(authenticationService: authService))
    }

    var body: some Scene {
        WindowGroup {
            let imageFetchingService = ImgurImageFetchingServiceInteractor()
            let photoGalleryViewModel = PhotoGalleryViewModel(imageFetchingServiceInteractor: imageFetchingService)
            let imagePickerViewModel = ImagePickerViewModel(imageFetchingService: imageFetchingService)
            
            ContentView(authViewModel: authViewModel, photoGalleryViewModel: photoGalleryViewModel, imagePickerViewModel: imagePickerViewModel)
        }
    }
}

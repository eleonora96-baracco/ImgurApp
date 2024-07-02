import SwiftUI

struct ContentView: View {
    @StateObject var authViewModel = AuthViewModel(authenticationService: ImgurAuthenticationServiceInteractor())
    @StateObject var photoGalleryViewModel: PhotoGalleryViewModel
    @StateObject var contentViewModel: ContentViewModel

    @State private var isShowingCamera = false
    @State private var isShowingPhotoPicker = false

    init() {
        let authService = ImgurAuthenticationServiceInteractor()
        let imageFetchingService = ImgurImageFetchingServiceInteractor()
        _photoGalleryViewModel = StateObject(wrappedValue: PhotoGalleryViewModel(imageFetchingServiceInteractor: ImgurImageFetchingServiceInteractor(), accessToken: authService.accessToken))
        _contentViewModel = StateObject(wrappedValue: ContentViewModel(imageFetchingService: imageFetchingService, accessToken: authService.accessToken))
    }

    var body: some View {
        NavigationView {
            if authViewModel.isLoggedIn {
                VStack {
                    PhotoGalleryView(viewModel: photoGalleryViewModel)

                    Button("Open Camera") {
                        isShowingCamera = true
                    }
                    .padding()
                    .sheet(isPresented: $isShowingCamera) {
                        CameraView(image: $contentViewModel.selectedImage)
                    }

                    Button("Upload an image") {
                        isShowingPhotoPicker = true
                    }
                    .padding()
                    .sheet(isPresented: $isShowingPhotoPicker) {
                        PhotoPickersView(image: $contentViewModel.selectedImage1, isPresented: $isShowingPhotoPicker)
                    }
                }
                .navigationTitle("Photo Gallery")
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button(action: {
                            authViewModel.logout()
                        }) {
                            Text("Logout")
                        }
                    }
                }
                .onChange(of: contentViewModel.selectedImage1) { 
                        contentViewModel.uploadImage { result in
                            switch result {
                                case .success(let imgurImage):
                                    photoGalleryViewModel.addPhoto(imgurImage)
                                case .failure(let error):
                                    contentViewModel.errorMessage = error
                            }
                    }
                }
            } else {
                LoginView(authViewModel: authViewModel)
            }
        }
        .alert(item: $authViewModel.errorMessage) { error in
            Alert(title: Text("Error"), message: Text(error.message), dismissButton: .default(Text("OK")))
        }
        .alert(item: $contentViewModel.errorMessage) { error in
            Alert(title: Text("Error"), message: Text(error.message), dismissButton: .default(Text("OK")))
        }
    }
}

#Preview {
    ContentView()
}

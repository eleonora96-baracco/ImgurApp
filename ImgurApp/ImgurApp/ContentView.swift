import SwiftUI

struct ContentView: View {
    @StateObject var authViewModel = AuthViewModel(authenticationService: ImgurAuthenticationServiceInteractor())
    @StateObject var photoGalleryViewModel: PhotoGalleryViewModel
    @StateObject var imagePickerViewModel: ImagePickerViewModel

    @State private var isShowingCamera = false
    @State private var isShowingPhotoPicker = false

    init() {
        let authService = ImgurAuthenticationServiceInteractor()
        let imageFetchingService = ImgurImageFetchingServiceInteractor()
        _photoGalleryViewModel = StateObject(wrappedValue: PhotoGalleryViewModel(imageFetchingServiceInteractor: ImgurImageFetchingServiceInteractor(), accessToken: authService.accessToken))
        _imagePickerViewModel = StateObject(wrappedValue: ImagePickerViewModel(imageFetchingService: imageFetchingService, accessToken: authService.accessToken))
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
                        CameraView(imagePickerViewModel: imagePickerViewModel)
                    }

                    Button("Upload an image") {
                        isShowingPhotoPicker = true
                    }
                    .padding()
                    .sheet(isPresented: $isShowingPhotoPicker) {
                        PhotoPickersView(isPresented: $isShowingPhotoPicker, imagePickerViewModel: imagePickerViewModel)
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
                .onChange(of: imagePickerViewModel.selectedImage) {
                    imagePickerViewModel.uploadImage { result in
                            switch result {
                                case .success(let imgurImage):
                                    photoGalleryViewModel.addPhoto(imgurImage)
                                case .failure(let error):
                                imagePickerViewModel.errorMessage = error
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
        .alert(item: $imagePickerViewModel.errorMessage) { error in
            Alert(title: Text("Error"), message: Text(error.message), dismissButton: .default(Text("OK")))
        }
    }
}

#Preview {
    ContentView()
}

import SwiftUI

struct ContentView: View {
    @StateObject var authViewModel = AuthViewModel(authenticationService: ImgurAuthenticationServiceInteractor())
    @StateObject var photoGalleryViewModel: PhotoGalleryViewModel
    @StateObject var imagePickerViewModel: ImagePickerViewModel

    @State private var isShowingCamera = false
    @State private var isShowingPhotoPicker = false

    init(authViewModel: AuthViewModel, photoGalleryViewModel: PhotoGalleryViewModel, imagePickerViewModel: ImagePickerViewModel) {
        _authViewModel = StateObject(wrappedValue: authViewModel)
        _photoGalleryViewModel = StateObject(wrappedValue: photoGalleryViewModel)
        _imagePickerViewModel = StateObject(wrappedValue: imagePickerViewModel)
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
                    Button("Upload an image") {
                        isShowingPhotoPicker = true
                    }
                    .padding()
                }
                .sheet(isPresented: $isShowingCamera) {
                    CameraView(imagePickerViewModel: imagePickerViewModel)
                }
                .sheet(isPresented: $isShowingPhotoPicker) {
                    PhotoPickersView(isPresented: $isShowingPhotoPicker, imagePickerViewModel: imagePickerViewModel)
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
        .overlay(ErrorAlertView(error: $imagePickerViewModel.errorMessage))
        .overlay(ErrorAlertView(error: $authViewModel.errorMessage))
    }
}


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
                    bottomView
                }
                .shadow(radius: 5)
                .background(Color.baseGreen)
                .sheet(isPresented: $isShowingCamera) {
                    CameraView(imagePickerViewModel: imagePickerViewModel)
                    .overlay(ErrorAlertView(error: $imagePickerViewModel.errorMessage))
                }
                .sheet(isPresented: $isShowingPhotoPicker) {
                    PhotoPickersView(isPresented: $isShowingPhotoPicker, imagePickerViewModel: imagePickerViewModel)
                    .overlay(ErrorAlertView(error: $imagePickerViewModel.errorMessage))
                }
                .navigationTitle("Photo Gallery")
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button(action: {
                            authViewModel.logout()
                        }) {
                            Text("Logout")
                        }
                        .foregroundStyle(.darkGreen)
                    }
                }
                .onChange(of: imagePickerViewModel.selectedImage) {
                    handleImageChange()
                }
            } else {
                LoginView(authViewModel: authViewModel)
                .overlay(ErrorAlertView(error: $authViewModel.errorMessage))
            }
        }
        .background(Color.customWhite)
        
    }
    
    @ViewBuilder private var bottomView: some View {
        VStack {
            Button("Open Camera") {
                isShowingCamera = true
            }
            .buttonStyle(GreenButton())
            .padding()
            Button("Upload an image") {
                isShowingPhotoPicker = true
            }
            .buttonStyle(GreenButton())
            .padding()
        }
    }
    
    private func handleImageChange() {
        imagePickerViewModel.uploadImage { result in
            switch result {
            case .success(let imgurImage):
                photoGalleryViewModel.addPhoto(imgurImage)
            case .failure(let error):
                imagePickerViewModel.errorMessage = error
            }
        }
    }
}

struct GreenButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(Color.customGreen)
            .foregroundColor(.customWhite)
            .clipShape(Capsule())
    }
}



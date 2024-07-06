import PhotosUI
import SwiftUI


struct PhotoPickersView: View {
    
    @State private var pickerItem: PhotosPickerItem?
    @State private var selectedImage: Image?
    @Binding var isPresented: Bool
    @ObservedObject var imagePickerViewModel: ImagePickerViewModel
    
    var body: some View {
        VStack {
            PhotosPicker("Select a picture to upload", selection: $pickerItem, matching: .images)
        }
        .onChange(of: pickerItem) {
            Task {
                selectedImage = try await pickerItem?.loadTransferable(type: Image.self)
                let data = try await pickerItem?.loadTransferable(type: Data.self)
                imagePickerViewModel.selectImageFromFile(data)
                isPresented = false
            }
        }
        selectedImage?
            .resizable()
            .scaledToFit()
    }
}


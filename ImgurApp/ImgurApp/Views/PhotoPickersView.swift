import PhotosUI
import SwiftUI


struct PhotoPickersView: View {
    
    @State private var pickerItem: PhotosPickerItem?
    @State private var selectedImage: Image?
    @Binding var image: Data?
    
    var body: some View {
        VStack {
            PhotosPicker("Select a picture", selection: $pickerItem, matching: .images)
        }
        .onChange(of: pickerItem) {
            Task {
                selectedImage = try await pickerItem?.loadTransferable(type: Image.self)
                image = try await pickerItem?.loadTransferable(type: Data.self)
            }
        }
        selectedImage?
            .resizable()
            .scaledToFit()
    }
}


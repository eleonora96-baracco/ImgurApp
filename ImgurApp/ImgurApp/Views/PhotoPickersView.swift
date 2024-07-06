import PhotosUI
import SwiftUI


struct PhotoPickersView: View {
    
    @State private var pickerItem: PhotosPickerItem?
    @State private var selectedImage: Image?
    @Binding var isPresented: Bool
    @ObservedObject var imagePickerViewModel: ImagePickerViewModel
    
    var body: some View {
        VStack {
            HStack() {
                PhotosPicker("Select a picture", selection: $pickerItem, matching: .images)
                Spacer()
                Button("Upload") {
                    Task {
                        let data = try await pickerItem?.loadTransferable(type: Data.self)
                        imagePickerViewModel.selectImageFromFile(data)
                    }
                    isPresented = false
                }
            }
            .padding()
            .foregroundStyle(.darkGreen)
            .onChange(of: pickerItem) {
                Task {
                    selectedImage = try await pickerItem?.loadTransferable(type: Image.self)
                }
            }
            selectedImage?
                .resizable()
                .scaledToFit()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.customWhite)
    }
}


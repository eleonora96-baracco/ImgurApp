import PhotosUI
import SwiftUI

struct PhotoPickersView: View {
    
    @State private var pickerItem: PhotosPickerItem?
    @State private var selectedImage: Image?
    @Binding var isPresented: Bool
    @ObservedObject var imagePickerViewModel: ImagePickerViewModel
    
    var body: some View {
        VStack {
            HStack {
                PhotosPicker("Select a picture", selection: $pickerItem, matching: .images)
                Spacer()
                Button("Upload") {
                    Task {
                        if let data = try? await pickerItem?.loadTransferable(type: Data.self) {
                            imagePickerViewModel.selectImageFromFile(data)
                        }
                        isPresented = false
                    }
                }
                .disabled(selectedImage == nil)
                .padding()
                .background(selectedImage == nil ? .customCream : .customGreen)
                .foregroundColor(.white)
                .clipShape(Capsule())
            }
            .padding()
            .foregroundStyle(.darkGreen)
            .onChange(of: pickerItem) {
                Task {
                    if let image = try? await pickerItem?.loadTransferable(type: Image.self) {
                        selectedImage = image
                    }
                }
            }
            
            if let image = selectedImage {
                image
                    .resizable()
                    .scaledToFit()
                    .padding()
            } else {
                Image(systemName: "photo")
                    .resizable()
                    .scaledToFit()
                    .padding()
                    .foregroundColor(.customCream)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.customWhite)
    }
}

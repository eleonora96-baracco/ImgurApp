import SwiftUI

struct PhotoGalleryView: View {
    @ObservedObject var viewModel: PhotoGalleryViewModel
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        VStack {
            if viewModel.photos.isEmpty {
                Text("No photos uploaded yet")
                    .padding()
            } else {
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 20) {
                        ForEach(viewModel.photos) { photo in
                            ZStack(alignment: .topTrailing) {
                                VStack {
                                    AsyncImage(url: URL(string: photo.link)) { image in
                                        image
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(width: 150, height: 150)
                                            .border(Color.gray, width: 2)
                                            .clipped()
                                            .cornerRadius(10)
                                            .shadow(radius: 5)
                                    } placeholder: {
                                        ProgressView()
                                            .frame(width: 150, height: 150)
                                    }
                                }
                                
                                Button(action: {
                                    if let index = viewModel.photos.firstIndex(where: { $0.id == photo.id }) {
                                        viewModel.removePhoto(at: index)
                                    }
                                }) {
                                    Image(systemName: "trash")
                                        .padding(10)
                                        .background(Color.black.opacity(0.5))
                                        .foregroundColor(.white)
                                        .clipShape(Circle())
                                        .shadow(radius: 5)
                                }
                                .padding([.top, .trailing], 8)
                            }
                        }
                    }
                    .padding()
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.customWhite)
        .onAppear {
            viewModel.fetchPhotos()
        }
        .overlay(ErrorAlertView(error: $viewModel.errorMessage))
    }
}

import SwiftUI

struct PhotoGalleryView: View {
    @ObservedObject var viewModel: PhotoGalleryViewModel

    var body: some View {
        VStack {
            if viewModel.photos.isEmpty {
                Text("No photos uploaded yet")
                    .padding()
            } else {
                List {
                    ForEach(viewModel.photos) { photo in
                        VStack {
//                            if let title = photo.title {
//                                Text(title)
//                                    .font(.headline)
//                            }
                            AsyncImage(url: URL(string: photo.link)) { image in
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                            } placeholder: {
                                ProgressView()
                            }
                        }
                    }
                    .onDelete { indexSet in
                        indexSet.forEach { index in
                            viewModel.removePhoto(at: index)
                        }
                    }
                }
            }

//            Button("Fetch Photos") {
//                viewModel.fetchPhotos()
//            }
//            .padding()
        }
        .alert(item: $viewModel.errorMessage) { error in
            Alert(title: Text("Error"), message: Text(error.message), dismissButton: .default(Text("OK")))
        }
    }
}

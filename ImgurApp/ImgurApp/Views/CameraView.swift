import SwiftUI
import UIKit

struct CameraView: UIViewControllerRepresentable {
    @ObservedObject var imagePickerViewModel: ImagePickerViewModel

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        var parent: CameraView
        
        init(_ parent: CameraView) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
//                parent.image = image
                parent.imagePickerViewModel.selectImageFromCamera(image)
//                parent.imagePickerViewModel.uploadImage { result in
//                    switch result {
//                    case .success(let imgurImage):
//                        print("Image uploaded successfully: \(imgurImage.link)")
//                    case .failure(let error):
//                        print("Error uploading image: \(error.message)")
//                    }
//                }
            }
            
            picker.dismiss(animated: true)
        }
    }
}

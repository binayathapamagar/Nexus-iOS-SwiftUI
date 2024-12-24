//
//  CameraPicker.swift
//  Nexus
//
//  Created by BINAYA THAPA MAGAR on 2024-11-18.
//

import SwiftUI
import PhotosUI

struct CameraPicker: UIViewControllerRepresentable {
    
    // MARK: Properties
    
    @Binding var selectedImage: UIImage?
    
    // MARK: Methods
    
    func makeUIViewController(context: Context) -> some UIImagePickerController {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .camera
        imagePicker.delegate = context.coordinator
        return imagePicker
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
    
    func makeCoordinator() -> CameraPicker.Coordinator {
        Coordinator(parent: self)
    }
    
    //Inner class
    
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        
        // MARK: Properties
        
        var parent: CameraPicker
        
        // MARK: Initializers
        
        init(parent: CameraPicker) {
            self.parent = parent
        }
        
        // MARK: Methods
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                self.parent.selectedImage = image
                picker.dismiss(animated: true)
                
                //Save image
                PHPhotoLibrary.shared().performChanges {
                    let creationRequest = PHAssetChangeRequest.creationRequestForAsset(from: image)
                    PHAssetCollectionChangeRequest(
                        for: PHAssetCollection())?.addAssets([creationRequest.placeholderForCreatedAsset!] as NSArray
                        )
                }
            } else {
                print(#function, "Error: Image not available from original image property.")
            }
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true)
        }
        
    }
    
}

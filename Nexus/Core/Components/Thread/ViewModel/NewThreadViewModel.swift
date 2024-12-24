//
//  NewThreadViewModel.swift
//  Nexus
//
//  Created by BINAYA THAPA MAGAR on 2024-11-17.
//

import SwiftUI
import PhotosUI
import AVFoundation

class NewThreadViewModel: ObservableObject {
    @Published var selectedItem: PhotosPickerItem? {
        didSet {
            Task { await loadPhotosImage() }
        }
    }
    @Published var capturedImage: UIImage? {
        didSet {
            guard let image = capturedImage else { return }
            self.uiImage = image
            self.threadImage = Image(uiImage: image)
        }
    }
    @Published var threadImage: Image?
    @Published var showLoadingSpinner = false
    @Published var showAlert: Bool = false
    @Published var errorMessage: String?
    @Published var photoPermissionGranted: Bool = true
    @Published var cameraPermissionGranted: Bool = false
    @Published var showCameraPicker = false
    
    var uiImage: UIImage?
    
    @MainActor
    private func loadPhotosImage() async {
        guard let item = selectedItem else { return }
        guard let data = try? await item.loadTransferable(type: Data.self) else { return }
        guard let uiImage = UIImage(data: data) else { return }
        self.uiImage = uiImage
        self.threadImage = Image(uiImage: uiImage)
    }
    
    func clearSelectedPic() {
        self.threadImage = nil
        self.uiImage = nil
        self.selectedItem = nil
    }
    
}

// MARK: - Permissions Handling

extension NewThreadViewModel {
    
    /// Check permission for Photos and Camera
    func checkPermission(for type: PermissionType) {
        switch type {
        case .photos:
            checkPhotosPermission()
        case .camera:
            checkCameraPermission()
        }
    }
    
    // MARK: Photos Permissions
    private func checkPhotosPermission() {
//        print(#function, "DEBUG: Checking permission for Photos")
//        switch PHPhotoLibrary.authorizationStatus() {
//        case .authorized:
//            self.photoPermissionGranted = true
//        case .notDetermined:
//            self.requestPhotosPermission()
//        case .denied, .limited, .restricted:
//            self.photoPermissionGranted = false
//            self.errorMessage = "Photo library access is required to select an image. Please enable photo library permissions in your device settings."
//            self.showAlert = true
//        @unknown default:
//            return
//        }
    }
    
    private func requestPhotosPermission() {
        print(#function, "DEBUG: Requesting Photos permissions...")
        PHPhotoLibrary.requestAuthorization { status in
            DispatchQueue.main.async {
                switch status {
                case .authorized:
                    self.photoPermissionGranted = true
                case .denied, .notDetermined:
                    self.photoPermissionGranted = false
                    self.errorMessage = "Photo library access was denied."
                    self.showAlert = true
                case .limited, .restricted:
                    self.photoPermissionGranted = false
                    self.errorMessage = "Limited access to the photo library."
                    self.showAlert = true
                @unknown default:
                    self.errorMessage = "An unknown error occurred. Please try again."
                    self.showAlert = true
                    return
                }
            }
        }
    }
    
    // MARK: Camera Permissions
    private func checkCameraPermission() {
        print(#function, "DEBUG: Checking permission for Camera")
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            self.cameraPermissionGranted = true
        case .notDetermined:
            self.requestCameraPermission()
        case .denied, .restricted:
            self.cameraPermissionGranted = false
            self.errorMessage = "Camera access is required to take photos. Please enable camera permissions in your device settings."
            self.showAlert = true
        @unknown default:
            self.errorMessage = "An unknown error occurred. Please try again."
            self.showAlert = true
            return
        }
    }
    
    private func requestCameraPermission() {
        print(#function, "DEBUG: Requesting Camera permissions...")
        AVCaptureDevice.requestAccess(for: .video) { granted in
            DispatchQueue.main.async {
                if granted {
                    self.cameraPermissionGranted = true
                } else {
                    self.cameraPermissionGranted = false
                    self.errorMessage = "Camera access was denied."
                    self.showAlert = true
                }
            }
        }
    }
}

// MARK: - PermissionType Enum
extension NewThreadViewModel {
    enum PermissionType {
        case photos
        case camera
    }
}

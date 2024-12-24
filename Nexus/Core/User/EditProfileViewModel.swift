//
//  EditProfileViewModel.swift
//  Nexus
//
//  Created by BINAYA THAPA MAGAR on 2024-10-09.
//

import SwiftUI
import PhotosUI

class EditProfileViewModel: ObservableObject {
    @Published var selectedItem: PhotosPickerItem? {
        didSet {
            Task { await loadPhotosImage() }
        }
    }
    @Published var username: String = ""
    @Published var bio: String = ""
    @Published var link: String = ""
    @Published var isPrivate: Bool = false
    @Published var profileImage: Image?
    @Published var showLoadingSpinner = false

    private var uiImage: UIImage?
    
    // Error messages
    @Published var errorMessage: String?
    
    func loadUserData(user: User) {
        self.username = user.username
        self.bio = user.bio ?? ""
        self.link = user.link ?? ""
        self.isPrivate = user.isPrivate
    }
    
    @MainActor
    private func loadPhotosImage() async {
        guard let item = selectedItem else { return }
        guard let data = try? await item.loadTransferable(type: Data.self) else { return }
        guard let uiImage = UIImage(data: data) else { return }
        self.uiImage = uiImage
        self.profileImage = Image(uiImage: uiImage)
    }
    
    @MainActor
    func updateUserData(with userId: String) async throws {
        showLoadingSpinner = true

        defer {
            showLoadingSpinner = false
        }
        
        var dataToUpdate: [String: Any] = [
            "bio": bio,
            "link": link,
            "isPrivate": isPrivate
        ]
        
        if !username.isEmpty {
            dataToUpdate["username"] = username
        }
        
        // Update the profile image if it was changed
        if let image = self.uiImage {
            guard let imageUrl = try await ImageUploader.uploadUserProfileImage(for: .Profile, image, userId: userId) else { return }
            dataToUpdate["profileImageUrl"] = imageUrl
        }
        
        // Call the UserService to update the user's profile data
        try await UserService.shared.updateUserProfile(with: dataToUpdate)
    }
    
}

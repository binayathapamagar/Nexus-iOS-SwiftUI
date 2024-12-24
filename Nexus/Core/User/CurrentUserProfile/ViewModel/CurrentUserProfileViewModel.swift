//
//  ProfileViewModel.swift
//  Nexus
//
//  Created by BINAYA THAPA MAGAR on 2024-09-26.
//

import Foundation
import Combine
import PhotosUI
import SwiftUI
import FirebaseDynamicLinks

@MainActor
class CurrentUserProfileViewModel: ObservableObject {
    @Published var currentUser: User?
    @Published var userFollowersCount = 0
    @Published var showLoadingSpinner = false
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        setupSubscribers()
    }
    
    private func setupSubscribers() {
        showLoadingSpinner = true

        defer {
            showLoadingSpinner = false
        }
        
        UserService.shared.$currentUser.sink { [weak self] user in
            guard let self else { return }
            currentUser = user
            Task {
                guard let uId = user?.id, !uId.isEmpty else { return }
                self.userFollowersCount = try await UserService.shared.getUserFollowersCountWith(userId: uId)
            }
        }.store(in: &cancellables)
    }
    
    // MARK: - Dynamic Link Generation
    func generateProfileShareLink(completion: @escaping (URL?) -> Void) {
        guard let user = currentUser else {
            print("No current user available")
            completion(nil)
            return
        }
        
        // Ensure base URL is valid
        guard let baseURL = URL(string: "https://nexusg6.page.link/share/\(user.id)") else {
            print("Invalid base URL")
            completion(nil)
            return
        }
        
        let domainURIPrefix = "https://nexusg6.page.link"
        
        // Create the DynamicLinkComponents with the provided URL and domain URI prefix
        let linkBuilder = DynamicLinkComponents(link: baseURL, domainURIPrefix: domainURIPrefix)
        
        // iOS parameters (Ensure the app bundle identifier is valid)
        guard let bundleID = Bundle.main.bundleIdentifier else {
            print("Invalid bundle identifier")
            completion(nil)
            return
        }
        
        linkBuilder?.iOSParameters = DynamicLinkIOSParameters(bundleID: bundleID)
        
        // Optional adding app's App Store ID
        // linkBuilder?.iOSParameters?.appStoreID = "YOUR_APP_STORE_ID"
        
        // Social meta tags for customization when shared on social media
        linkBuilder?.socialMetaTagParameters = DynamicLinkSocialMetaTagParameters()
        linkBuilder?.socialMetaTagParameters?.title = "\(user.fullName)'s Profile"
        linkBuilder?.socialMetaTagParameters?.descriptionText = "Check out \(user.fullName)'s profile on Nexus!"
        
        // Generate the shortened dynamic link
        linkBuilder?.shorten { url, warnings, error in
            if let error = error {
                print("Error generating Dynamic Link: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            if let warnings = warnings {
                warnings.forEach { warning in
                    print("Warning: \(warning)")
                }
            }
            
            // Return the generated dynamic link URL
            completion(url)
        }
    }
    
}

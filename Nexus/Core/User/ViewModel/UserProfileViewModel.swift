//
//  UserProfileViewModel.swift
//  Nexus
//
//  Created by BINAYA THAPA MAGAR on 2024-12-04.
//

import Foundation
import Combine
import PhotosUI
import SwiftUI
import FirebaseDynamicLinks

@MainActor
class UserProfileViewModel: ObservableObject {
    @Published var user: User
    @Published var followingUser = false
    @Published var showLoadingSpinner = false
        
    init(user: User) {
        self.user = user
        setup()
    }
    
    private func setup() {
        showLoadingSpinner = true
        
        defer {
            showLoadingSpinner = false
        }
        
        guard !user.id.isEmpty else { return }
        
        Task { self.user.followers = try await UserService.shared.getUserFollowersCountWith(userId: user.id) }
        Task { try await self.checkFollowingStatus() }
    }
    
    func checkFollowingStatus() async throws {
        self.followingUser = try await FollowService.checkIfFollowingUserWith(userId: user.id)
    }
    
    func manageFollowAction() async throws {
        self.followingUser ? try await unFollowUser() : try await followUser()
    }
    
    func followUser() async throws {
        showLoadingSpinner = true
        
        defer {
            showLoadingSpinner = false
        }
        
        try await FollowService.followUserWith(selectedUser: user)
        
        followingUser = true
        user.followers += 1
    }
    
    func unFollowUser() async throws {
        showLoadingSpinner = true
        
        defer {
            showLoadingSpinner = false
        }
        
        try await FollowService.unFollowUserWith(selectedUser: user)
        
        followingUser = false
        user.followers -= 1
    }
    
    // MARK: - Dynamic Link Generation
    func generateProfileShareLink(completion: @escaping (URL?) -> Void) {
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

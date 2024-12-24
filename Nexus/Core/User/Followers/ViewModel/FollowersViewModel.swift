//
//  FollowersViewModel.swift
//  Nexus
//
//  Created by BINAYA THAPA MAGAR on 2024-12-04.
//

import Foundation

class FollowersViewModel: ObservableObject {
    @Published var followers = [User]()
    @Published var showLoadingSpinner = false

    let user: User
    
    init(user: User) {
        self.user = user
        Task { try await fetchFollowers() }
    }
    
    @MainActor
    func fetchFollowers() async throws {
        
        showLoadingSpinner = true
        
        defer {
            showLoadingSpinner = false
        }
                
        self.followers = try await FollowService.fetchFollowers(withUserId: user.id)
    }
    
}

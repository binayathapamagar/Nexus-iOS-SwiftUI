//
//  ActivityCellViewModel.swift
//  Nexus
//
//  Created by BINAYA THAPA MAGAR on 2024-12-05.
//

import SwiftUI

@MainActor
class ActivityCellViewModel: ObservableObject {
    @Published var user: User
    @Published var followingUser = false
    @Published var showLoadingSpinner = false

    let notification: Notification
    
    init(notificationSenderUser: User, notification: Notification) {
        self.user = notificationSenderUser
        self.notification = notification
        setup()
    }
    
    private func setup() {
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
}

//
//  ActivityViewModel.swift
//  Nexus
//
//  Created by BINAYA THAPA MAGAR on 2024-12-05.
//

import Foundation

@MainActor
class ActivityViewModel: ObservableObject {
    @Published var notifications = [Notification]()
    @Published var filteredNotifications = [Notification]()
    @Published var showLoadingSpinner = false
    @Published var selectedFilterTab: ActivityFilterOption = .all {
        didSet {
            filterNotifications()
        }
    }
    
    init() {        
        Task {
            try await fetchNotifications()
        }
    }
    
    func fetchNotifications() async throws {
        showLoadingSpinner = true
        
        defer {
            showLoadingSpinner = false
        }
        
        self.notifications = try await NotificationService.fetchNotifications()
        self.filteredNotifications = self.notifications
        
        try await fetchUserAndThreadForNotification()
    }
    
    private func fetchUserAndThreadForNotification() async throws {
        guard let loggedInUser = UserService.shared.currentUser else { return }
        
        for i in 0 ..< notifications.count {
            let notification = notifications[i]
            let senderId = notification.senderId
            
            do {
                let notificationSender = try await UserService.fetchUser(with: senderId)
                notifications[i].sender = notificationSender
                notifications[i].notificationOwner = loggedInUser
            } catch {
                print(#function, "DEBUG: Error fetching user for senderId \(senderId): \(error)")
                continue // Skip to the next notification if the user fetch fails
            }
            
            // Fetch associated thread if present
            if let threadId = notification.threadId {
                do {
                    var thread = try await ThreadService.fetchThread(threadId: threadId)
                    thread.user = loggedInUser
                    notifications[i].thread = thread
                } catch {
                    print(#function, "DEBUG: Error fetching thread for threadId \(threadId): \(error)")
                }
            }
        }
        
        self.filteredNotifications = notifications
    }

    
    func updateFilter(with newFilterValue: ActivityFilterOption) {
        selectedFilterTab = newFilterValue
    }
    
    private func filterNotifications() {
        if selectedFilterTab == .all {
            filteredNotifications = notifications
        } else {
            filteredNotifications = notifications.filter { $0.filterType == selectedFilterTab }
        }
    }
    
}

//
//  ExploreViewModel.swift
//  Nexus
//
//  Created by BINAYA THAPA MAGAR on 2024-10-07.
//

import Foundation
import Combine

class ExploreViewModel: ObservableObject {
    
    @Published var users = [User]()
    @Published var searchText = ""
    @Published var showLoadingSpinner = false
    
    private var cancellables = Set<AnyCancellable>()
    
    var filteredUsers: [User] {
        if searchText.isEmpty {
            return users
        } else {
            return users.filter { $0.username.lowercased().contains(searchText.lowercased()) }
        }
    }
    
    init() {
        Task { try await fetchUsers() }
        setupSearchBinding()
    }
    
    @MainActor
    func fetchUsers() async throws {
        showLoadingSpinner = true
        
        defer {
            showLoadingSpinner = false
        }
        
        self.users = try await UserService.fetchUsers()
    }
    
    /// Set up Combine to react to changes in the search text.
    private func setupSearchBinding() {
        $searchText
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main) // Optional: debounce for smoother updates
            .removeDuplicates()
            .sink { [weak self] _ in
                self?.objectWillChange.send() // Manually trigger UI update for filteredUsers
            }
            .store(in: &cancellables)
    }
    
}

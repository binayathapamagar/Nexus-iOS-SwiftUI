//
//  FeedViewModel.swift
//  Nexus
//
//  Created by BINAYA THAPA MAGAR on 2024-10-10.
//

import Foundation

@MainActor
class FeedViewModel: ObservableObject {
    @Published var threads = [Thread]()
    @Published var showLoadingSpinner = false
    
    init() {
        Task { try await fetchThreads() }
    }
    
    func fetchThreads() async throws {
        showLoadingSpinner = true
        
        self.threads = try await ThreadService.fetchThreads()
        showLoadingSpinner = false 

        try await fetchUserForThread()
    }
    
    private func fetchUserForThread() async throws {
        for i in 0 ..< threads.count {
            let thread = threads[i]
            let ownerUid = thread.ownerUid
            let threadOwner = try await UserService.fetchUser(with: ownerUid)
            
            print("i = \(i) | Threads count = \(threads.count)")
            
            threads[i].user = threadOwner
        }
    }
    
    func insertNewThread(_ thread: Thread) {
        threads.insert(thread, at: 0)
    }
    
}

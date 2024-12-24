//
//  ThreadDetailsViewModel.swift
//  Nexus
//
//  Created by BINAYA THAPA MAGAR on 2024-10-26.
//

import Foundation

@MainActor
class ThreadDetailsViewModel: ObservableObject {
    @Published var replies = [ThreadReply]()
    @Published var showLoadingSpinner = false
    
    private let thread: Thread
    
    init(thread: Thread) {
        self.thread = thread
        Task { try await fetchThreadReplies() }
    }
    
    private func fetchThreadReplies() async throws {
        showLoadingSpinner = true
        
        defer {
            showLoadingSpinner = false
        }
        
        self.replies = try await ThreadReplyService.fetchReplies(for: thread, replyType: .thread)
        try await fetchUserDataForReplies()
    }
    
    private func fetchUserDataForReplies() async throws {
        for i in 0 ..< replies.count {
            let reply = replies[i]
            
            /*
             async let user: Using async let here initiates the fetchUser operation asynchronously without waiting for it to complete. This means each fetchUser call in the loop can run in parallel.

             try await user: The try await here is necessary to retrieve the result of user. Although fetchUser is started asynchronously, we still need to wait for it to complete before assigning the result to replyUser. Using try await on user allows us to get the result when it's ready and ensures any errors are handled appropriately.
             */
            
            async let user = try await UserService.fetchUser(with: reply.threadReplyOwnerUid)
            self.replies[i].replyUser = try await user
        }
    }
    
    func insertNewThreadReply(_ threadReply: ThreadReply) {
        replies.insert(threadReply, at: 0)
    }
    
}


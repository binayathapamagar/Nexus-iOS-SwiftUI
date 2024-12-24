//
//  UserContentListViewModel.swift
//  Nexus
//
//  Created by BINAYA THAPA MAGAR on 2024-10-11.
//

import Foundation

@MainActor
class UserContentListViewModel: ObservableObject {
    @Published var threads = [Thread]()
    @Published var replies = [ThreadReply]()
    @Published var repostedThreads = [Thread]()
    @Published var likedThreads = [Thread]()
    @Published var emptyMessage: String = ""
    @Published var selectedFilter: ProfileThreadFilter = .threads
    
    let user: User
    
    init(user: User) {
        self.user = user
        
        //Fetching the user's threads and replies concurrently instead of sequentially by using different tasks.
//        Task {
//            try await fetchData()
//            updateEmptyMessage(forFilter: selectedFilter)
//        }
    }
    
    func fetchData() async throws {
        async let _ = try await fetchUserThreads()
        async let _ = try await fetchUserReplies()
        async let _ = try await fetchUserReposts()
        async let _ = try await fetchUserLikes()
        updateEmptyMessage(forFilter: selectedFilter)
    }
    
    func updateFilter(with newFilterValue: ProfileThreadFilter) {
        selectedFilter = newFilterValue
        updateEmptyMessage(forFilter: selectedFilter)
    }
    
    func updateEmptyMessage(forFilter filter: ProfileThreadFilter) {
        let isEmpty: Bool

        switch filter {
        case .threads:
            isEmpty = threads.isEmpty
        case .replies:
            isEmpty = replies.isEmpty
        case .reposts:
            isEmpty = repostedThreads.isEmpty
        case .likes:
            isEmpty = likedThreads.isEmpty
        }
        
        emptyMessage = isEmpty ? filter.emptyMessage : ""
    }
    
}

// MARK: - Threads

extension UserContentListViewModel {
    
    func fetchUserThreads() async throws {
        var threads = try await ThreadService.fetchUserThreads(with: user.id)
        
        for i in 0..<threads.count {
            threads[i].user = self.user
        }
        
        self.threads = threads
    }
        
}

// MARK: - Replies

extension UserContentListViewModel {
    
    func fetchUserReplies() async throws {
        self.replies = try await ThreadService.fetchThreadReplies(forUser: user)
        try await fetchReplyThreadData()
    }
    
    func fetchReplyThreadData() async throws {
        
        for i in 0..<replies.count {
            let reply = replies[i]
            
            var thread = try await ThreadService.fetchThread(threadId: reply.threadId)
            thread.user = try await UserService.fetchUser(with: thread.ownerUid)
            
            replies[i].thread = thread
        }
        
    }
    
}

// MARK: - Reposts

extension UserContentListViewModel {
    
    func fetchUserReposts() async throws {
        self.repostedThreads = try await RepostService.fetchUserRepostedThreads(withUserUid: user.id)
    }
    
}

// MARK: - Likes

extension UserContentListViewModel {
    
    func fetchUserLikes() async throws {
        self.likedThreads = try await LikeService.fetchUserLikedThreads(withUserUid: user.id)
    }
    
}

//
//  ContentActionButtonsViewModel.swift
//  Nexus
//
//  Created by BINAYA THAPA MAGAR on 2024-10-16.
//

import Foundation
import Firebase
import FirebaseAuth

@MainActor
class ContentActionButtonsViewModel: ObservableObject {
    @Published var thread: Thread
    
    init(thread: Thread) {
        self.thread = thread
        Task { try await checkIfUserLikedThread() }
        Task { try await checkIfUserHasRepostedThread()}
    }
    
}

// MARK: - Repost

extension ContentActionButtonsViewModel {
    
    func repostThread() async throws {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let repostData = Repost(
            threadId: thread.id,
            threadOwnerUid: thread.ownerUid,
            threadRepostOwnerUid: uid,
            timestamp: Timestamp()
        )
        
        try await RepostService.repostThread(thread, with: repostData)
        
        self.thread.didRepost = true
        self.thread.reposts += 1
    }
    
    func unRepostThread() async throws {
        try await RepostService.unRepostThread(thread)
        self.thread.didRepost = false
        self.thread.reposts -= 1
    }
    
    func handleRepostAction() async throws {
        guard let didRepost = thread.didRepost else { return }
        if didRepost {
            try await unRepostThread()
        } else {
            try await repostThread()
        }
    }
    
    func checkIfUserHasRepostedThread() async throws {
        let didRepost = try await RepostService.userHasRepostedThread(thread)
        
        //Only publishing the changes if the user has liked it before as
        //by default it will be false. We would firing off unnecessary
        //publishing events to update the UI.
        if didRepost {
            thread.didRepost = true
        }
    }
    
}

// MARK: - Like

extension ContentActionButtonsViewModel {
    
    func likeThread() async throws {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let likeData = Like(
            threadId: thread.id,
            threadOwnerUid: thread.ownerUid,
            threadLikeOwnerUid: uid,
            timestamp: Timestamp()
        )
        
        try await LikeService.likeThread(thread, with: likeData)
        
        self.thread.didLike = true
        self.thread.likes += 1
    }
    
    func unlikeThread() async throws {
        try await LikeService.unLikeThread(thread)
        self.thread.didLike = false
        self.thread.likes -= 1
    }
    
    func handleLikeAction() async throws {
        guard let didLike = thread.didLike else { return }
        if didLike {
            try await unlikeThread()
        } else {
            try await likeThread()
        }
    }
    
    func checkIfUserLikedThread() async throws {
        let didLike = try await LikeService.userHasLikedThread(thread)
        
        //Only publishing the changes if the user has liked it before as
        //by default it will be false. We would firing off unnecessary
        //publishing events to update the UI.
        if didLike {
            thread.didLike = true
        }
    }
    
}

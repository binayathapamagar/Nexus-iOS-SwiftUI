//
//  ProfileThreadFilter.swift
//  Nexus
//
//  Created by BINAYA THAPA MAGAR on 2024-09-26.
//

import Foundation

enum ProfileThreadFilter: Int, CaseIterable, Identifiable {
    case threads
    case replies
    case reposts
    case likes
    
    var title: String {
        switch self {
        case .threads: return "Threads"
        case .replies: return "Replies"
        case .reposts: return "Reposts"
        case .likes: return "Likes"
        }
    }
    
    var emptyMessage: String {
        switch self {
        case .threads: return "You haven't posted any threads yet."
        case .replies: return "You haven't posted any replies yet."
        case .reposts: return "You haven't reposted any threads yet."
        case .likes: return "You haven't liked any threads yet."
        }
    }
    
    var id: Int { return self.rawValue }
}

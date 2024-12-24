//
//  ActivityFilterOption.swift
//  Nexus
//
//  Created by BINAYA THAPA MAGAR on 2024-12-05.
//

import Foundation

enum ActivityFilterOption: Int, CaseIterable, Identifiable {
    case all
    case follow
    case reply
    case repost
    case like
    
    var title: String {
        switch self {
        case .all: return "All"
        case .follow: return "Follows"
        case .reply: return "Replies"
        case .repost: return "Reposts"
        case .like: return "Likes"
        }
    }
    
    var rawName: String {
        switch self {
        case .all: return "all"
        case .follow: return "follow"
        case .reply: return "reply"
        case .repost: return "repost"
        case .like: return "like"
        }
    }
    
    var emptyMessage: String {
        switch self {
        case .all: return "Nothing to see here yet."
        case .follow: return "No following notifications to see yet."
        case .reply: return "No reply notifications to see yet."
        case .repost: return "No repost notifications to see yet."
        case .like: return "No repost notifications to see yet."
        }
    }
    
    var id: Int { return self.rawValue }
}

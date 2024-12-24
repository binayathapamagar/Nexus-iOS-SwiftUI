//
//  User.swift
//  Nexus
//
//  Created by BINAYA THAPA MAGAR on 2024-09-26.
//

import Foundation

struct User: Identifiable, Codable, Hashable {
    let id: String
    let username: String
    let fullName: String
    let email: String
    let joinedDate: String
    var isPrivate: Bool = false
    var followers: Int = 0
    var following: Int = 0
    var profileImageUrl: String?
    var bio: String?
    var link: String?
}

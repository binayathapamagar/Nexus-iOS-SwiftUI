//
//  CircularProgressView.swift
//  Nexus
//
//  Created by BINAYA THAPA MAGAR on 2024-09-26.
//

import SwiftUI
import Kingfisher
import FirebaseAuth

enum ProfileImageSize {
    case xxSmall
    case xSmall
    case small
    case medium
    case large
    case xlarge
    
    var dimension: CGFloat {
        switch self {
        case .xxSmall: return 28
        case .xSmall: return 32
        case .small: return 40
        case .medium: return 48
        case .large: return 64
        case .xlarge: return 80
        }
    }
}

struct CircularProfileImageView: View {
    let user: User?
    let size: ProfileImageSize
    let allowsNavigation: Bool
    
    init(user: User?, size: ProfileImageSize, allowsNavigation: Bool) {
        self.user = user
        self.size = size
        self.allowsNavigation = allowsNavigation
    }
    
    var body: some View {
        if let user {
            if allowsNavigation {
                NavigationLink {
                    if let loggedInUserUid = Auth.auth().currentUser?.uid {
                        if loggedInUserUid == user.id {
                            CurrentUserProfileView()
                        } else {
                            UserProfileView(user: user)
                        }
                    }
                } label: {
                    ProfileImageViewContent(user: user, size: size)
                }
            } else {
                ProfileImageViewContent(user: user, size: size)
            }
        }
    }
}

#Preview {
    CircularProfileImageView(
        user: DeveloperPreview.shared.user,
        size: .small,
        allowsNavigation: false
    )
}

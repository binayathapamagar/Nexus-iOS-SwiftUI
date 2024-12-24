//
//  ProfileImageViewContent.swift
//  Nexus
//
//  Created by BINAYA THAPA MAGAR on 2024-11-26.
//

import SwiftUI
import Kingfisher

struct ProfileImageViewContent: View {
    let user: User
    let size: ProfileImageSize

    var body: some View {
        if let profileImageUrl = user.profileImageUrl {
            KFImage(URL(string: profileImageUrl))
                .resizable()
                .scaledToFill()
                .frame(width: size.dimension, height: size.dimension)
                .clipShape(Circle())
        } else {
            Image(systemName: "person.circle.fill")
                .resizable()
                .frame(width: size.dimension, height: size.dimension)
                .foregroundStyle(Color(.systemGray4))
        }
    }
}

#Preview {
    ProfileImageViewContent(
        user: DeveloperPreview.shared.user,
        size: .small
    )
}

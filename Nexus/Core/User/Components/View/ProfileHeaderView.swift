//
//  ProfileHeaderView.swift
//  Nexus
//
//  Created by BINAYA THAPA MAGAR on 2024-10-07.
//

import SwiftUI

struct ProfileHeaderView: View {
    var user: User?
    
    private var followersCount: Int {
        user?.followers ?? 0
    }
    
    var body: some View {
        HStack(alignment: .top) {
            //Content
            VStack(alignment: .leading, spacing: 12) {
                //Name and username
                VStack(alignment: .leading, spacing: 4) {
                    Text(user?.fullName ?? "Full Name")
                        .font(.title2)
                        .fontWeight(.semibold)
                    
                    Text("@\(user?.username ?? "Username")")
                        .font(.subheadline)
                }
                
                //Bio, link and followers count
                if let bio = user?.bio, !bio.isEmpty {
                    Text(bio)
                        .font(.footnote)
                }
                
                if let link = user?.link, !link.isEmpty {
                    Text(link)
                        .foregroundStyle(.linkBlue)
                        .font(.footnote)
                }
                
                if followersCount > 0 {
                    NavigationLink {
                        if let user {
                            FollowersView(user: user)
                        }
                    } label: {
                        Text(
                            followersCount > 1
                            ? "\(followersCount) followers"
                            : "\(followersCount) follower"
                        )
                        .foregroundStyle(.gray)
                        .font(.caption)
                    }
                }
            }//VStack
            
            Spacer()
            
            CircularProfileImageView(
                user: user,
                size: .small,
                allowsNavigation: false
            )
        }//HStack
    }
}

#Preview {
    ProfileHeaderView(user: DeveloperPreview.shared.user)
}

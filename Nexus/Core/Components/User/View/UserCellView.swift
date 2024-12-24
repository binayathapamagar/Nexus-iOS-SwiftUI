//
//  UserCellView.swift
//  Nexus
//
//  Created by BINAYA THAPA MAGAR on 2024-09-26.
//

import SwiftUI

struct UserCellView: View {
    @StateObject var viewModel: UserCellViewModel
    
    @Binding var showLoadingSpinner: Bool
    
    let fromExploreView: Bool
    
    private var loggedInUserId: String {
        return UserService.shared.currentUser?.id ?? ""
    }
    
    private var user: User {
        viewModel.user
    }
    
    private var followersCount: Int {
        user.followers
    }
    
    init(user: User, showLoadingSpinner: Binding<Bool>, fromExploreView:Bool) {
        self._showLoadingSpinner = showLoadingSpinner
        self._viewModel = StateObject(
            wrappedValue: UserCellViewModel(
                user: user,
                showLoadingSpinner: showLoadingSpinner
            )
        )
        self.fromExploreView = fromExploreView
    }
    
    var body: some View {
        HStack {
            CircularProfileImageView(
                user: user,
                size: .small,
                allowsNavigation: fromExploreView
            )
            
            VStack(alignment: .leading, spacing: 4) {
                Text(user.username)
                    .fontWeight(.semibold)
                
                Text(user.fullName)
                    .foregroundStyle(Color(.systemGray))
                
                if followersCount > 0 {
                    Text(
                        followersCount > 1
                        ? "\(followersCount) followers"
                        : "\(followersCount) follower"
                    )
                    .foregroundStyle(.gray)
                    .font(.caption)
                    .fontWeight(.medium)
                    .padding(.vertical, 4)
                }
            }//VStack
            .font(.subheadline)
            .padding(.leading, 8)
            
            Spacer()
            
            if user.id != loggedInUserId {
                Button(action: {
                    Task { try await viewModel.manageFollowAction() }
                }, label: {
                    Text(
                        viewModel.followingUser
                        ? "Following"
                        : "Follow"
                    )
                    .foregroundStyle(
                        viewModel.followingUser
                        ? .appPrimary
                        : .appSecondary
                    )
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .frame(width: 100, height: 32)
                    .background(
                        viewModel.followingUser
                        ? .appSecondary
                        : .appPrimary
                    )
                    .clipShape(
                        RoundedRectangle(cornerRadius: 10)
                    )
                    .overlay {
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color(.systemGray4), lineWidth: 1)
                    }
                })
            }
            
        }//HStack
        .padding(.vertical, 4)
        .padding(.horizontal)
    }
}

#Preview {
    UserCellView(
        user: DeveloperPreview.shared.user,
        showLoadingSpinner: .constant(false),
        fromExploreView: true
    )
}

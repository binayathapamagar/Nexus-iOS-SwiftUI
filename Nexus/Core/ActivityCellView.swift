//
//  ActivityCellView.swift
//  Nexus
//
//  Created by BINAYA THAPA MAGAR on 2024-12-05.
//

import SwiftUI

struct ActivityCellView: View {
    @StateObject var viewModel: ActivityCellViewModel
    
    private var loggedInUserId: String {
        UserService.shared.currentUser?.id ?? ""
    }
    
    private var notificationSender: User {
        viewModel.user
    }
    
    init(notification: Notification, sender: User) {
        self._viewModel = StateObject(
            wrappedValue: ActivityCellViewModel(
                notificationSenderUser: sender,
                notification: notification
            )
        )
    }
    
    var body: some View {
        VStack {
            HStack {
                ZStack(alignment: .bottomTrailing) {
                    CircularProfileImageView(
                        user: viewModel.user,
                        size: .small,
                        allowsNavigation: true
                    )
                    
                    switch viewModel.notification.filterType {
                    case .all:
                        EmptyView()
                            .foregroundStyle(.clear)
                            .background(.clear)
                    case .follow:
                        Image(systemName:"person.circle.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 18, height: 18)
                            .foregroundStyle(.purple)
                    case .reply:
                        Image(systemName:"bubble.right.circle")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 20, height: 20)
                            .foregroundStyle(.teal)
                    case .repost:
                        Image(systemName:"arrow.rectanglepath")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 18, height: 18)
                            .foregroundStyle(.green)
                    case .like:
                        Image(systemName:"heart.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 18, height: 18)
                            .foregroundStyle(.red)
                    }
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        
                        //Username
                        Text(notificationSender.username)
                            .font(.subheadline)
                            .fontWeight(.semibold)
                        
                        Text(viewModel.notification.timestamp.timeAgoDisplay())
                            .font(.footnote)
                            .foregroundStyle(Color(.systemGray2))
                        
                        Spacer()
                        
                    }//HStack
                    
                    Text(viewModel.notification.message)
                        .font(.subheadline)
                        .foregroundStyle(Color(.systemGray))
                        .multilineTextAlignment(.leading)
                    
                }//VStack
                .font(.subheadline)
                .padding(.leading, 8)
                
                Spacer()
                
                if notificationSender.id != loggedInUserId {
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
            .padding(.vertical, 12)
            .padding(.horizontal)
            Divider()
        }//VStack
    }
}

#Preview {
    ActivityCellView(
        notification: DeveloperPreview.shared.notification,
        sender: DeveloperPreview.shared.user
    )
}

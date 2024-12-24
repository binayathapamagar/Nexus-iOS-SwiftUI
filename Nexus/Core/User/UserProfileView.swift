//
//  UserProfileView.swift
//  Nexus
//
//  Created by BINAYA THAPA MAGAR on 2024-10-07.
//

import SwiftUI

struct UserProfileView: View {
    @State private var selectedFilter: ProfileThreadFilter = .threads
    @Namespace var animation
    
    @StateObject var viewModel: UserProfileViewModel
    
    private var currentUser: User {
        viewModel.user
    }
    
    init(user: User) {
        self._viewModel = StateObject(
            wrappedValue: UserProfileViewModel(user: user)
        )
    }
    
    var body: some View {
        ZStack {
            ScrollView {
                //Header
                VStack(spacing: 20) {
                    ProfileHeaderView(user: viewModel.user)
                    .padding(.horizontal)
                   
                    HStack {
                        Button(action: {
                            Task { try await viewModel.manageFollowAction() }
                        }, label: {
                            Text(viewModel.followingUser ? "Following" : "Follow")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .foregroundStyle(
                                    viewModel.followingUser
                                    ? .appPrimary
                                    : .appSecondary
                                )
                                .frame(maxWidth: .infinity, minHeight: 32)
                                .background(
                                    viewModel.followingUser
                                    ? .appSecondary
                                    : .appPrimary
                                )
                                .clipShape(
                                    RoundedRectangle(cornerRadius: 8)
                                )
                                .overlay {
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color(.systemGray4), lineWidth: 1)
                                }
                        })
                        
                        Button(action: shareProfile, label: {
                            ProfileButtonView(title: "Share profile")
                        })
                    }//HStack
                    .padding(.horizontal)
                    
                    UserContentListView(user: viewModel.user)
                }//VStack
                .padding(.top, 16)
            }//ScrollView
            .scrollIndicators(.hidden)
            
            if viewModel.showLoadingSpinner {
                Color.black.opacity(0.4)
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    AuthProgressView()
                }//VStack
            }
        }//ZStack
        .tint(.appPrimary)
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Functions

extension UserProfileView {
    
    private func shareProfile() {
        viewModel.showLoadingSpinner = true
        viewModel.generateProfileShareLink { url in
            viewModel.showLoadingSpinner = false
            guard let url = url else { return }
            let activityVC = UIActivityViewController(activityItems: [url], applicationActivities: nil)
            UIApplication.shared.windows.first?.rootViewController?.present(activityVC, animated: true)
        }
    }
    
}

#Preview {
    UserProfileView(user: DeveloperPreview.shared.user)
}

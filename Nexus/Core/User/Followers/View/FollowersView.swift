//
//  FollowersView.swift
//  Nexus
//
//  Created by BINAYA THAPA MAGAR on 2024-12-04.
//

import SwiftUI

struct FollowersView: View {
    @StateObject private var viewModel: FollowersViewModel
    
    var user: User
    
    init(user: User) {
        self.user = user
        
        self._viewModel = StateObject(
            wrappedValue: FollowersViewModel(
                user: user
            )
        )
    }
    
    var body: some View {
        ZStack {
            GeometryReader { proxy in
                ScrollView {
                    if viewModel.followers.isEmpty {
                        VStack(alignment: .center, spacing: 16) {
                            Text(
                                "You're not following anyone yet. Start discovering and connecting!"
                            )
                            .font(.subheadline)
                            .multilineTextAlignment(.center)
                        }//VStack
                        .padding()
                        .frame(height: proxy.size.height * 0.9)
                    } else {
                        LazyVStack {
                            ForEach(viewModel.followers) { user in
                                VStack {
                                    UserCellView(
                                        user: user,
                                        showLoadingSpinner: $viewModel.showLoadingSpinner, fromExploreView: false
                                    )
                                    
                                    Divider()
                                }//VStack
                                .padding(.vertical, 4)
                            }//ForEach
                        }//LazyVStack
                        .padding(.top, 8)
                    }
                }//ScrollView
            }//GeometryReader
            .navigationDestination(for: User.self, destination: { user in
                UserProfileView(user: user)
            })
            .tint(.appPrimary)
            
            if viewModel.showLoadingSpinner {
                Color.black.opacity(0.4)
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    AuthProgressView()
                }//VStack
            }
        }//ZStack
        .refreshable {
            Task { try await viewModel.fetchFollowers() }
        }//refreshable
        .navigationTitle("Followers")
    }
}

#Preview {
    FollowersView(user: DeveloperPreview.shared.user)
}

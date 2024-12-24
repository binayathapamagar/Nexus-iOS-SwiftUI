//
//  ExploreView.swift
//  Nexus
//
//  Created by BINAYA THAPA MAGAR on 2024-09-26.
//

import SwiftUI

struct ExploreView: View {
    
    @StateObject private var viewModel = ExploreViewModel()
    
    var body: some View {
        NavigationStack {
            ZStack {
                ScrollView {
                    LazyVStack {
                        ForEach(viewModel.filteredUsers) { user in
                            NavigationLink(value: user) {
                                VStack {
                                    UserCellView(
                                        user: user,
                                        showLoadingSpinner: $viewModel.showLoadingSpinner, fromExploreView: true
                                    )
                                    
                                    Divider()
                                }//VStack
                                .padding(.vertical, 4)
                            }
                        }//ForEach
                    }//LazyVStack
                }//ScrollView
                .navigationDestination(for: User.self, destination: { user in
                    UserProfileView(user: user)
                })
                .searchable(text: $viewModel.searchText, prompt: "Search")
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
                Task { try await viewModel.fetchUsers() }
            }//refreshable
            .navigationTitle("Search")
        }//NavigationStack
    }
}

#Preview {
    ExploreView()
}

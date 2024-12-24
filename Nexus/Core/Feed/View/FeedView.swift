//
//  FeedView.swift
//  Nexus
//
//  Created by BINAYA THAPA MAGAR on 2024-09-26.
//

import SwiftUI

struct FeedView: View {
    @StateObject private var viewModel = FeedViewModel()
    @Binding var showCreateThread: Bool
    @Binding var showExploreView: Bool
    
    @EnvironmentObject var createThreadViewModel: CreateThreadViewModel
    
    private var user: User? {
        UserService.shared.currentUser
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                GeometryReader { proxy in
                    ScrollView {
                        NewThreadView(
                            viewModel: NewThreadViewModel(),
                            content: .constant(""),
                            threadImageUrl: .constant(""),
                            inFeedView: true,
                            user: user
                        )
                        .padding(.top)
                        .padding(.horizontal)
                        .onTapGesture {
                            showCreateThread = true
                        }
                        Divider()
                            .padding(.top)
                        
                        if viewModel.threads.isEmpty {
                            VStack {
                                EmptyFeedView(showExploreView: $showExploreView)
                            }
                            .frame(height: proxy.size.height * 0.7)
                        } else {
                            LazyVStack(content: {
                                ForEach(viewModel.threads) { thread in
                                    ThreadCellView(thread: thread)
                                }//ForEach
                            })//LazyVStack
                        }
                    }//ScrollView
                }//GeometryReader
                .scrollIndicators(.hidden)
                
                if viewModel.showLoadingSpinner {
                    Color.black.opacity(0.4)
                        .edgesIgnoringSafeArea(.all)
                    
                    VStack {
                        AuthProgressView()
                    }//VStack
                }
            }//ZStack
            //compactMap unwraps and discards nil values. Only non-nil values are passed downstream. This simplifies the code by ensuring only non-nil values are processed, making it more concise and readable.
            .onReceive(createThreadViewModel.$newThread.compactMap { $0 }) { thread in
                viewModel.insertNewThread(thread)
            }
            //Updating the feed when the user follows someone.
            .onReceive(UserService.shared.$currentUser, perform: { _ in
                guard UserService.shared.currentUser != nil else { return } 
                Task {
                    try await viewModel.fetchThreads()
                }
            })
            .refreshable {
                Task { try await viewModel.fetchThreads() }
            }//refreshable
            .toolbar {
                ToolbarItem(placement: .principal) {
                    HStack {
                        Image(.logo)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 40)
                    }
                }//ToolbarItemØ
            }//toolbar
            .navigationBarTitleDisplayMode(.inline)
        }//NavigationStack
    }
}

#Preview {
    FeedView(
        showCreateThread: .constant(false),
        showExploreView: .constant(false)
    )
    .environmentObject(CreateThreadViewModel())
}

//
//  ContentActionButtonsView.swift
//  Nexus
//
//  Created by BINAYA THAPA MAGAR on 2024-10-16.
//

import SwiftUI

struct ContentActionButtonsView: View {
    @ObservedObject private var viewModel: ContentActionButtonsViewModel
    @StateObject private var threadReplyViewModel = ThreadReplyViewModel()

    @State private var showReplySheet: Bool = false
    
    //Only for the live addition of replies
    var threadDetailsViewModel: ThreadDetailsViewModel?
    
    init(thread: Thread, threadDetailsViewModel: ThreadDetailsViewModel? = nil) {
        self.viewModel = ContentActionButtonsViewModel(thread: thread)
        guard let threadDetailsViewModel else { return }
        self.threadDetailsViewModel = threadDetailsViewModel
    }
    
    private var thread: Thread {
        viewModel.thread
    }
    
    private var didLike: Bool {
        viewModel.thread.didLike ?? false
    }
    
    private var didRepost: Bool {
        viewModel.thread.didRepost ?? false
    }
    
    var body: some View {
        HStack(alignment: .bottom, spacing: 24) {
            HStack(spacing: 4) {
                Button(action: {
                    Task { try await viewModel.handleLikeAction() }
                }, label: {
                    Image(systemName:didLike ? "heart.fill" : "heart")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 18, height: 18)
                        .foregroundStyle(didLike ? .red : .secondary)
                })
                
                if thread.likes > 0 {
                    Text("\(thread.likes)")
                        .foregroundStyle(didLike ? .red : .secondary)
                        .font(.system(size: 14))
                }
            }
            HStack(spacing: 4) {
                Button(action: {
                    showReplySheet.toggle()
                }, label: {
                    Image(systemName: "bubble.right")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 18, height: 18)
                        .foregroundStyle(.secondary)
                })
                
                if thread.replyCount > 0 {
                    Text("\(thread.replyCount)")
                        .foregroundStyle(.secondary)
                        .font(.system(size: 14))
                }
            }
            HStack(spacing: 4) {
                Button(action: {
                    Task { try await viewModel.handleRepostAction() }
                }, label: {
                    Image(systemName: "arrow.rectanglepath")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 20, height: 20)
                        .foregroundStyle(didRepost ? .green : .secondary)
                })
                
                if thread.reposts > 0 {
                    Text("\(thread.reposts)")
                        .foregroundStyle(didRepost ? .green : .secondary)
                        .font(.system(size: 14))
                }
            }
            HStack(spacing: 4) {
                Button(action: {}, label: {
                    Image(systemName: "paperplane")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 18, height: 18)
                        .foregroundStyle(.secondary)
                })
                
                if thread.shares > 0 {
                    Text("\(thread.shares)")
                        .foregroundStyle(.secondary)
                        .font(.system(size: 14))
                }
            }
        }//HStack
        .onReceive(threadReplyViewModel.$newThreadReply.compactMap { $0 }) { threadReply in
            threadDetailsViewModel?.insertNewThreadReply(threadReply)
        }
        .sheet(isPresented: $showReplySheet) {
            ThreadReplyView(
                viewModel: threadReplyViewModel,
                thread: thread
            )
        }
    }
}

#Preview {
    ContentActionButtonsView(thread: DeveloperPreview.shared.thread)
}


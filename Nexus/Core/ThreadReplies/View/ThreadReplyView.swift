//
//  ThreadReplyView.swift
//  Nexus
//
//  Created by BINAYA THAPA MAGAR on 2024-10-19.
//

import SwiftUI
import Kingfisher

struct ThreadReplyView: View {
    @ObservedObject var viewModel: ThreadReplyViewModel
    @StateObject private var newThreadViewModel = NewThreadViewModel()
    @State private var replyImageUrl = ""
    @State private var reply: String = ""
    @State private var imageCoverData: ImageCoverData?

    @Environment(\.dismiss) var dismiss
    
    let thread: Thread
    
    private var threadUser: User? {
        thread.user
    }
    
    private var currentUser: User? {
        UserService.shared.currentUser
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    Divider()
                    
                    // MARK: - Thread
                    VStack(alignment: .leading, spacing: 16) {
                        HStack(alignment: .top) {
                            VStack {
                                CircularProfileImageView(
                                    user: threadUser,
                                    size: .small,
                                    allowsNavigation: false
                                )
                                
                                if thread.imageUrl == nil || thread.imageUrl?.isEmpty == true {
                                    Rectangle()
                                        .frame(
                                            width: 2,
                                            height: viewModel.threadViewHeight
                                        )
                                        .foregroundStyle(Color(.systemGray4))
                                }
                            }//VStack
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text(threadUser?.username ?? "username")
                                    .fontWeight(.semibold)
                                
                                if !thread.content.isEmpty {
                                    Text(thread.content)
                                        .font(.subheadline)
                                        .multilineTextAlignment(.leading)
                                }
                                
                                if let imageUrl = thread.imageUrl {
                                    KFImage(URL(string: imageUrl))
                                        .resizable()
                                        .scaledToFit()
                                        .aspectRatio(1, contentMode: .fit)
                                        .frame(
                                            alignment: .leading
                                        )
                                        .clipShape(
                                            RoundedRectangle(cornerRadius: 10)
                                        )
                                        .padding(.top, 8)
                                        .onTapGesture {
                                            imageCoverData = ImageCoverData(imageUrl: imageUrl)
                                        }
                                        .fullScreenCover(item: $imageCoverData, onDismiss: {
                                            print("Image dismissed")
                                        }) { imageCover in
                                            FullScreenImageView(imageUrl: imageCover.imageUrl) {
                                                imageCoverData = nil
                                            }
                                        }
                                }
                            }//VStack
                            .font(.subheadline)
                            
                            Spacer()
                        }//HStack
                        
                        // MARK: - Reply
                        NewThreadView(
                            viewModel: newThreadViewModel,
                            content: $reply,
                            threadImageUrl: $replyImageUrl,
                            inFeedView: false,
                            user: currentUser
                        )
                    }//VStack
                    .padding()
                    
                    Spacer()
                }//VStack
                if viewModel.showLoadingSpinner {
                    Color.black.opacity(0.4)
                        .edgesIgnoringSafeArea(.all)
                    
                    VStack {
                        AuthProgressView()
                    }
                }
            }//ZStack
            .onAppear {
                viewModel.setThreadViewHeight(with: thread)
            }
            .navigationTitle("Reply")
            .navigationBarTitleDisplayMode(.inline )
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .font(.subheadline)
                    .foregroundStyle(.appPrimary)
                }//ToolbarItem
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Post") {
                        Task {
                            try await viewModel.uploadThreadReply(
                                replyText: reply,
                                image: newThreadViewModel.uiImage,
                                thread: thread
                            )
                            dismiss()
                        }
                    }
                    .opacity(reply.isEmpty && newThreadViewModel.uiImage == nil ? 0.5 : 1.0)
                    .disabled(reply.isEmpty && newThreadViewModel.uiImage == nil)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundStyle(.appPrimary)
                }//ToolbarItem
            }//toolbar
        }//NavigationStack
    }
}

#Preview {
    ThreadReplyView(
        viewModel: ThreadReplyViewModel(),
        thread: DeveloperPreview.shared.thread
    )
}

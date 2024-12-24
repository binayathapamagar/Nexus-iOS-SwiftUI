//
//  ThreadDetailsView.swift
//  Nexus
//
//  Created by BINAYA THAPA MAGAR on 2024-10-26.
//

import SwiftUI
import Kingfisher

struct ThreadDetailsView: View {
    @StateObject var viewModel: ThreadDetailsViewModel    
    @State private var imageCoverData: ImageCoverData?

    let thread: Thread
    
    init(thread: Thread) {
        self.thread = thread
        self._viewModel = StateObject(
            wrappedValue: ThreadDetailsViewModel(thread: thread)
        )
    }
    
    var body: some View {
        ZStack {
            ScrollView {
                VStack {
                    HStack {
                        CircularProfileImageView(
                            user: thread.user,
                            size: .small,
                            allowsNavigation: true
                        )
                        
                        Text(thread.user?.username ?? "@username")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                        
                        Text(thread.timestamp.timeAgoDisplay())
                            .font(.footnote)
                            .foregroundStyle(Color(.systemGray3))
                        
                        Spacer()
                        
                        Button(action: {}, label: {
                            Image(systemName: "ellipsis")
                                .foregroundStyle(Color(.darkGray))
                        })
                    }//HStack
                    .padding(.horizontal)
                    
                    VStack(alignment: .leading, spacing: 12) {
                        
                        if !thread.content.isEmpty {
                            Text(thread.content)
                                .font(.subheadline)
                                .multilineTextAlignment(.leading)
                        }
                        
                        if let imageUrl = thread.imageUrl {
                            //Putting the image in a HStack and a spacer so that the image's width is the size of it's content and not the full max width of the parent VStack.
                            HStack {
                                KFImage(URL(string: imageUrl))
                                    .resizable()
                                    .scaledToFit()
                                    .frame(
                                        maxHeight: (UIScreen.current?.bounds.height ?? 0.0) * 0.3,
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
                                
                                Spacer()
                            }//HStack
                        }
                        
                        ContentActionButtonsView(
                            thread: thread,
                            threadDetailsViewModel: viewModel
                        )
                    }//VStack
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                    
                    // MARK: - Replies & Activity
                    
                    if !viewModel.replies.isEmpty || thread.likes > 0 {
                        Divider()
                            .padding(.top)
                        
                        HStack {
                            Text("Replies")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                            
                            Spacer()
                            
                            Button {
                                print("Show user likes")
                            } label: {
                                HStack(spacing: 4) {
                                    Text("View activity")
                                        .font(.subheadline)
                                    
                                    Image(systemName: "chevron.right")
                                }//HStack
                                .font(.subheadline)
                                .foregroundStyle(.dividerBG)
                            }//Button
                        }//HStack
                        .padding(.vertical, 8)
                        .padding(.horizontal)
                        
                        Divider()
                            .padding(.bottom)
                        
                        if !viewModel.replies.isEmpty {
                            LazyVStack{
                                ForEach(viewModel.replies) { reply in
                                    ThreadReplyCellView(threadReply: reply)
                                }
                            }//LazyVStack
                        } else {
                            Text("No replies yet.")
                                .font(.subheadline)
                        }
                    }
                }//VStack
            }//ScrollView
            .padding(.vertical)
            
            if viewModel.showLoadingSpinner {
                Color.black.opacity(0.4)
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    AuthProgressView()
                }
            }
        }
        .navigationTitle("Thread")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        ThreadDetailsView(thread: DeveloperPreview.shared.thread)
    }
}

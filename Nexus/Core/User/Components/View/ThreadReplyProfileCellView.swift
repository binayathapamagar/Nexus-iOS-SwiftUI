//
//  ThreadReplyProfileCellView.swift
//  Nexus
//
//  Created by BINAYA THAPA MAGAR on 2024-11-21.
//

import SwiftUI
import Kingfisher

struct ThreadReplyProfileCellView: View {
    @State private var imageCoverData: ImageCoverData?
    @State private var threadViewHeight: CGFloat = 24 //Default value to fall back on

    let reply: ThreadReply
    
    var body: some View {
        VStack {
            VStack(alignment: .leading) {
                
                // MARK: - Thread View
                if let thread = reply.thread {
                    HStack(alignment: .top, spacing: 12) {
                        VStack {
                            CircularProfileImageView(
                                user: thread.user,
                                size: .small,
                                allowsNavigation: true
                            )
                            
                            if thread.imageUrl == nil || thread.imageUrl?.isEmpty == true {
                                Rectangle()
                                    .frame(
                                        width: 2,
                                        height: threadViewHeight
                                    )
                                    .foregroundStyle(Color(.systemGray4))
                            }
                        }//VStack
                        
                        VStack(alignment: .leading, spacing: 4) {
                            HStack {
                                
                                //Username
                                Text(thread.user?.username ?? "@username")
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                
                                Text(thread.timestamp.timeAgoDisplay())
                                    .font(.footnote)
                                    .foregroundStyle(Color(.systemGray2))
                            }//HStack
                            
                            //Thread content
                            if !thread.content.isEmpty {
                                Text(thread.content)
                                    .font(.subheadline)
                                    .multilineTextAlignment(.leading)
                            }
                            
                            if let imageUrl = thread.imageUrl {
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
                                
                            }
                            
                            //Action buttons
                            ContentActionButtonsView(thread: thread)
                                .padding(.vertical, 8)
                            
                        }//VStack
                        
                        Spacer()
                    }//HStack
                }
                
                // MARK: - Reply View
                HStack(alignment: .top) {
                    CircularProfileImageView(
                        user: reply.replyUser,
                        size: .small,
                        allowsNavigation: true
                    )
                    VStack(alignment: .leading, spacing: 4) {
                        HStack {
                            Text(reply.replyUser?.username ?? "@username")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                            
                            Text(reply.timestamp.timeAgoDisplay())
                                .font(.footnote)
                                .foregroundStyle(Color(.systemGray2))
                        }//HStack
                        
                        Text(reply.replyText)
                    }//VStack
                    .font(.subheadline)
                    
                    Spacer()
                    
                }//HStack
                
            }//VStack
            .padding(.top, 16)
            .padding(.horizontal)
            
            Divider()
                .padding(.top, 8)
        }//VStack
        .onAppear {
            if let thread = reply.thread {
                setThreadViewHeight(with: thread)
            }
        }
    }
}

#Preview {
    ThreadReplyProfileCellView(reply: DeveloperPreview.shared.threadReply)
}

extension  ThreadReplyProfileCellView {

    func setThreadViewHeight(with thread: Thread) {
        guard let screenWidth = UIScreen.current?.bounds.size.width else { return }
        let imageDimension: CGFloat = ProfileImageSize.small.dimension
        let padding: CGFloat = 16
        //        let spacing: CGFloat = 8
        let replyTextFieldWidth = screenWidth - imageDimension - padding
        //        let replyTextFieldWidth = screenWidth - imageDimension - padding - spacing
        
        let font = UIFont.systemFont(ofSize: 15)
        
        let threadContentHeight = thread.content.heightWithConstraintWidth(replyTextFieldWidth, font: font)
        
        print(#function, "DEBUG: Height of the thread content: \(threadContentHeight)")
        
        //        let rootVStackSpacing: CGFloat = 8
        //        let threadUsernameThreadContentSpacing: CGFloat = 4
        
        //Adding the image's height & the thread's content height
        threadViewHeight = threadContentHeight + imageDimension - padding
        
        //        threadViewHeight = threadContentHeight + imageDimension - padding - spacing - rootVStackSpacing - threadUsernameThreadContentSpacing
        
        print(#function, "DEBUG: Height of the thread view: \(threadViewHeight)")
    }
    
}

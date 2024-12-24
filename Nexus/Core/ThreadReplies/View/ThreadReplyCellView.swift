//
//  ThreadReplyCellView.swift
//  Nexus
//
//  Created by BINAYA THAPA MAGAR on 2024-11-04.
//

import SwiftUI
import Kingfisher

struct ThreadReplyCellView: View {
    let threadReply: ThreadReply
    
    private var replyUser: User? {
        threadReply.replyUser
    }
    
    var body: some View {
        VStack {
            HStack(alignment: .top, spacing: 12) {
                CircularProfileImageView(
                    user: replyUser,
                    size: .small,
                    allowsNavigation: true
                )
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        
                        //Username
                        Text(replyUser?.username ?? "@username")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                        
                        Text(threadReply.timestamp.timeAgoDisplay())
                            .font(.footnote)
                            .foregroundStyle(Color(.systemGray2))
                        
                        Spacer()
                        
                        Button(action: {}, label: {
                            Image(systemName: "ellipsis")
                                .foregroundStyle(Color(.darkGray))
                        })
                    }//HStack
                    
                    if !threadReply.replyText.isEmpty {
                        Text(threadReply.replyText)
                            .font(.subheadline)
                            .multilineTextAlignment(.leading)
                    }
                    
                    if let imageUrl = threadReply.imageUrl {
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
                    }
                    
                    //Tightly coupled to a thread so will have to make this View accept a generic value that can be a thread or a reply.
                    //Action buttons
                    //                    if let thread = threadReply.thread {
                    //                        ContentActionButtonsView(thread: thread)
                    //                            .padding(.vertical, 8)
                    //                    }
                    
                }//VStack
                
            }//HStack
            .padding(.horizontal)
            
            Divider()
                .padding(.vertical)
        }//VStack
    }
}

#Preview {
    ThreadReplyCellView(threadReply: DeveloperPreview.shared.threadReply)
}

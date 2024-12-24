//
//  ThreadCellView.swift
//  Nexus
//
//  Created by BINAYA THAPA MAGAR on 2024-09-26.
//

import SwiftUI
import Kingfisher

struct ThreadCellView: View {
    @State private var imageCoverData: ImageCoverData?
    
    let thread: Thread
    
    var body: some View {
        NavigationLink {
            ThreadDetailsView(thread: thread)
        } label: {
            VStack {
                HStack(alignment: .top, spacing: 12) {
                    CircularProfileImageView(
                        user: thread.user,
                        size: .small,
                        allowsNavigation: true
                    )
                    
                    VStack(alignment: .leading, spacing: 4) {
                        HStack {
                            
                            //Username
                            Text(thread.user?.username ?? "@username")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                            
                            Text(thread.timestamp.timeAgoDisplay())
                                .font(.footnote)
                                .foregroundStyle(Color(.systemGray2))
                            
                            Spacer()
                            
                            Button(action: {}, label: {
                                Image(systemName: "ellipsis")
                                    .foregroundStyle(Color(.darkGray))
                            })
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
                    
                }//HStack
                .padding(.horizontal)
                
                Divider()
            }//VStack
            .padding(.top)
        }//NavigationLink
    }
}

#Preview {
    ThreadCellView(thread: DeveloperPreview.shared.thread)
}

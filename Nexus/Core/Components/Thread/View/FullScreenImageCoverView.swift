//
//  FullScreenImageCoverView.swift
//  Nexus
//
//  Created by BINAYA THAPA MAGAR on 2024-12-05.
//

import SwiftUI
import Kingfisher

struct FullScreenImageView: View {
    let imageUrl: String
    var onDismiss: () -> Void
    
    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            
            VStack {
                KFImage(URL(string: imageUrl))
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.black)
                
                Spacer()
            }
            
            VStack {
                HStack {
                    Spacer()
                    Button(action: onDismiss) {
                        Image(systemName: "xmark.circle.fill")
                            .resizable()
                            .foregroundColor(.white)
                            .frame(width: 32, height: 32)
                            .padding()
                    }
                }
                Spacer()
            }
        }
        .onTapGesture {
            onDismiss()
        }
    }
}

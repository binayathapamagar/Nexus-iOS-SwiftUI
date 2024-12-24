//
//  CreateThreadView.swift
//  Nexus
//
//  Created by BINAYA THAPA MAGAR on 2024-09-26.
//

import SwiftUI

struct CreateThreadView: View {
    @StateObject private var newThreadViewModel = NewThreadViewModel()
    @ObservedObject var viewModel: CreateThreadViewModel
    @State private var content = ""
    @State private var threadImageUrl = ""
    @Environment(\.dismiss) var dismiss
    
    private var user: User? {
        UserService.shared.currentUser
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    NewThreadView(
                        viewModel: newThreadViewModel,
                        content: $content,
                        threadImageUrl: $threadImageUrl,
                        inFeedView: false,
                        user: user
                    )
                    
                    Spacer()
                }//VStack
                .padding() 
                
                if viewModel.showLoadingSpinner {
                    Color.black.opacity(0.4)
                        .edgesIgnoringSafeArea(.all)
                    
                    VStack {
                        AuthProgressView()
                    }//VStack
                }
            }//ZStack
            .navigationTitle("New Thread")
            .navigationBarTitleDisplayMode(.inline)
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
                            try await viewModel.uploadThread(
                                with: content,
                                image: newThreadViewModel.uiImage
                            )
                            dismiss()
                        }
                    }
                    .opacity(content.isEmpty && newThreadViewModel.uiImage == nil ? 0.5 : 1.0)
                    .disabled(content.isEmpty && newThreadViewModel.uiImage == nil)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundStyle(.appPrimary)
                }//ToolbarItem
            }//toolbar
        }//NavigationStack
    }
}

#Preview {
    CreateThreadView(viewModel: CreateThreadViewModel())
}

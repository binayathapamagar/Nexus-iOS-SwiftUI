//
//  ProfileView.swift
//  Nexus
//
//  Created by BINAYA THAPA MAGAR on 2024-09-26.
//

import SwiftUI

struct CurrentUserProfileView: View {
    
    @State private var showEditProfileView = false
    @StateObject private var viewModel = CurrentUserProfileViewModel()
    
    private var currentUser: User? {
        viewModel.currentUser
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                ScrollView {
                    VStack(spacing: 20) {
                        //Header
                        ProfileHeaderView(user: currentUser)
                            .padding(.horizontal)
                        
                        HStack {
                            Button(action: {
                                showEditProfileView.toggle()
                            }, label: {
                                ProfileButtonView(title: "Edit profile")
                            })
                            
                            Button(action: shareProfile, label: {
                                ProfileButtonView(title: "Share profile")
                            })
                        }//HStack
                        .padding(.horizontal)
                        
                        if let currentUser {
                            UserContentListView(user: currentUser)
                        }
                    }//VStack
                    .padding(.top, 16)
                }//ScrollView
                
                if viewModel.showLoadingSpinner {
                    Color.black.opacity(0.4)
                        .edgesIgnoringSafeArea(.all)
                    
                    VStack {
                        AuthProgressView()
                    }//VStack
                }
                
            }//ZStack
            .scrollIndicators(.hidden)
            .sheet(isPresented: $showEditProfileView, content: {
                if let currentUser {
                    EditProfileView(user: currentUser)
                }
            })
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button{
                        AuthService.shared.signOut()
                    } label: {
                        Image(systemName: "rectangle.portrait.and.arrow.right")
                    }
                }
            }
            .tint(.primary)
        }//NavigationStack
    }
}

// MARK: - Functions

extension CurrentUserProfileView {
    
    private func shareProfile() {
        viewModel.showLoadingSpinner = true
        viewModel.generateProfileShareLink { url in
            viewModel.showLoadingSpinner = false
            guard let url = url else { return }
            let activityVC = UIActivityViewController(activityItems: [url], applicationActivities: nil)
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let keyWindow = windowScene.windows.first(where: { $0.isKeyWindow }),
               let rootViewController = keyWindow.rootViewController {
                rootViewController.present(activityVC, animated: true)
            }

        }
    }
    
}

#Preview {
    CurrentUserProfileView()
}

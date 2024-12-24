//
//  EditProfileView.swift
//  Nexus
//
//  Created by BINAYA THAPA MAGAR on 2024-10-07.
//

import SwiftUI
import PhotosUI

struct EditProfileView: View {
    let user: User
    @State private var username = ""
    @State private var bio = ""
    @State private var link = ""
    @State private var isPrivate = false
    @Environment(\.dismiss) var dismiss
    @StateObject var viewModel = EditProfileViewModel()
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(.systemGroupedBackground)
                    .ignoresSafeArea(edges: [.bottom, .horizontal])
                
                VStack {
                    //Name and profile pic
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Name")
                                .fontWeight(.semibold)
                            
                            Text(user.fullName)
                        }
                        
                        Spacer()
                        
                        PhotosPicker(selection: $viewModel.selectedItem) {
                            if let image = viewModel.profileImage {
                                image
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 40, height: 40)
                                    .clipShape(Circle())
                            } else {
                                CircularProfileImageView(
                                    user: user,
                                    size: .small,
                                    allowsNavigation: false
                                )
                            }
                        }
                    }//HStack
                    
                    Divider()
                    
                    //Username
                    VStack(alignment: .leading) {
                        Text("Username")
                            .fontWeight(.semibold)
                        
                        TextField("Enter your username...", text: $viewModel.username, axis: .vertical)
                            .textInputAutocapitalization(.never)
                    }//VStack
                    
                    Divider()
                    
                    //Bio
                    VStack(alignment: .leading) {
                        Text("Bio")
                            .fontWeight(.semibold)
                        
                        TextField("Enter your bio...", text: $viewModel.bio, axis: .vertical)
                            .textInputAutocapitalization(.never)
                    }//VStack
                    
                    Divider()
                    
                    //Link
                    VStack(alignment: .leading) {
                        Text("Link")
                            .fontWeight(.semibold)
                        
                        TextField("Add link ...", text: $viewModel.link)
                            .textInputAutocapitalization(.never)
                    }//VStack
                    
                    Divider()
                    
                    Toggle("Private Profile", isOn: $viewModel.isPrivate)
                    
                }//VStack
                .font(.footnote)
                .padding()
                .background(.appSecondary)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .strokeBorder(Color(.systemGray4), lineWidth: 1)
                )
                .padding()
                
                if viewModel.showLoadingSpinner {
                    Color.black.opacity(0.4)
                        .edgesIgnoringSafeArea(.all)
                    
                    VStack {
                        AuthProgressView()
                    }//VStack
                }
                
            }//ZStack
            .navigationTitle("Edit Profile")
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
                    Button("Done") {
                        Task {
                            try await viewModel.updateUserData(with: user.id)
                            dismiss()
                        }
                    }
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundStyle(.appPrimary)
                }//ToolbarItem
            }//Toolbar
            .onAppear {
                viewModel.loadUserData(user: user)
            }
        }//NavigationStack
    }
}

#Preview {
    EditProfileView(user: DeveloperPreview.shared.user)
        .environmentObject(CurrentUserProfileViewModel())
}

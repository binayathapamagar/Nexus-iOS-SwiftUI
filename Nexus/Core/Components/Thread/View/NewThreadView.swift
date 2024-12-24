//
//  NewThreadView.swift
//  Nexus
//
//  Created by BINAYA THAPA MAGAR on 2024-10-03.
//

import SwiftUI
import PhotosUI

struct NewThreadView: View {
    @ObservedObject var viewModel: NewThreadViewModel
    @Binding var content: String
    @Binding var threadImageUrl: String
    
    let inFeedView: Bool
    let user: User?
    
    private var threadMaxCharacterLimit: Int {
        GlobalConstants.Threads.ThreadMaxCharacterLimit
    }
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            CircularProfileImageView(
                user: user,
                size: .small,
                allowsNavigation: false
            )
            
            VStack(alignment: .leading, spacing: 12) {
                VStack(alignment: .leading, spacing: 8) {
                    Text(user?.username ?? "@username")
                        .fontWeight(.semibold)
                    
                    if inFeedView {
                        Text("What's new?")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .foregroundStyle(.icon)
                    } else {
                        TextField("What's new?", text: $content, axis: .vertical)
                            .multilineTextAlignment(.leading)
                            .onChange(of: content) { oldValue, newValue in
                                if newValue.count > GlobalConstants.Threads.ThreadMaxCharacterLimit {
                                    content = String(
                                        newValue.prefix(threadMaxCharacterLimit)
                                    )
                                }
                            }
                    }
                    
                }//VStack
                .font(.subheadline)
                
                if let threadImage = viewModel.threadImage {
                    ZStack(alignment: .topTrailing) {
                        threadImage
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(
                                maxHeight: (UIScreen.current?.bounds.height ?? 0.0) * 0.3,
                                alignment: .leading
                            )
                            .clipShape(
                                RoundedRectangle(cornerRadius: 10)
                            )
                            .overlay(
                                Button {
                                    viewModel.clearSelectedPic()
                                } label: {
                                    Image(systemName: "xmark")
                                        .resizable()
                                        .frame(width: 12, height: 12)
                                        .foregroundStyle(.white)
                                        .padding(8)
                                        .background(Color.black.opacity(0.6))
                                        .clipShape(Circle())
                                }
                                .padding(8),
                                alignment: .topTrailing
                            )
                    }//ZStack
                }
                
                HStack(alignment: .bottom, spacing: 24) {
                    Button {
                        viewModel.checkPermission(for: .photos)
                    } label: {
                        if viewModel.photoPermissionGranted {
                            PhotosPicker(selection: $viewModel.selectedItem) {
                                Image(systemName: "photo")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 20, height: 20)
                                    .foregroundStyle(.icon)
                            }
                        } else {
                            Image(systemName: "photo")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 20, height: 20)
                                .foregroundStyle(.icon)
                        }
                    }//Button
                    .disabled(inFeedView)
                    
                    Button {
                        viewModel.checkPermission(for: .camera)
                        if viewModel.cameraPermissionGranted {
                            viewModel.showCameraPicker = true
                        }
                    } label: {
                        Image(systemName: "camera")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 20, height: 20)
                            .foregroundStyle(.icon)
                    }
                    .disabled(inFeedView)
                    
                    Spacer()
                }
            }//VStack
            .sheet(isPresented: $viewModel.showCameraPicker) {
                CameraPicker(selectedImage: $viewModel.capturedImage)
            }
            .alert(isPresented: $viewModel.showAlert) {
                Alert(
                    title: Text("Permission Required"),
                    message: Text(viewModel.errorMessage ?? ""),
                    primaryButton: .default(
                        Text("Go to Settings"),
                        action: {
                            if let appSettings = URL(string: UIApplication.openSettingsURLString) {
                                UIApplication.shared.open(appSettings)
                            }
                        }
                    ),
                    secondaryButton: .cancel(Text("Cancel"))
                )
            }
        }//HStack
    }
}

#Preview {
    NewThreadView(
        viewModel: NewThreadViewModel(),
        content: .constant(""),
        threadImageUrl: .constant(""),
        inFeedView: true,
        user: DeveloperPreview.shared.user
    )
}

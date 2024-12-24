//
//  RegistrationView.swift
//  Nexus
//
//  Created by BINAYA THAPA MAGAR on 2024-09-26.
//

import SwiftUI

struct RegistrationView: View {
    @StateObject private var viewModel = RegistrationViewModel()
    @State private var isPasswordVisible: Bool = false
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            
            Color.clear
                .contentShape(Rectangle())
                .onTapGesture {
                    self.hideKeyboard()
                }
            
            VStack {
                
                Spacer()
                
                Image(.logo)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 120, height: 120)
                    .padding()
                
                VStack {
                    
                    TextField("Enter your full name", text: $viewModel.fullName)
                        .modifier(TextFieldModifier())
                    
                    TextField("Enter your username", text: $viewModel.username)
                        .textInputAutocapitalization(.never)
                        .modifier(TextFieldModifier())
                    
                    TextField("Enter your email", text: $viewModel.email)
                        .keyboardType(.emailAddress)
                        .textInputAutocapitalization(.never)
                        .modifier(TextFieldModifier())
                    
                    ZStack(alignment: .trailing) {
                        if isPasswordVisible {
                            TextField("Enter your password", text: $viewModel.password)
                                .modifier(TextFieldModifier())
                        } else {
                            SecureField("Enter your password", text: $viewModel.password)
                                .modifier(TextFieldModifier())
                        }
                        Button(action: {
                            isPasswordVisible.toggle() // Toggle visibility
                        }) {
                            Image(
                                systemName: isPasswordVisible ? "eye" : "eye.slash"
                            )
                            .foregroundColor(.appPrimary.opacity(0.5))
                            .padding(.horizontal, 36) //Textfields have a 24 horizontal padding.
                        }
                    }
                    .padding(.top, 0.5)
                    
                }//VStack
                
                Button {
                    self.hideKeyboard()
                    Task { try await viewModel.createUser() }
                } label: {
                    Text("Register")
                        .modifier(AuthButtonModifier())
                }//Button
                .opacity(viewModel.fieldsAreEmpty ? 0.7 : 1)
                .disabled(viewModel.fieldsAreEmpty)
                
                Spacer()
                
                Divider()
                
                Button {
                    dismiss()
                } label: {
                    HStack(spacing: 3) {
                        Text("Already have an account?")
                        
                        Text("Sign In")
                            .fontWeight(.bold)
                    }//HStack
                    .foregroundStyle(.appPrimary)
                    .font(.footnote)
                    .padding(.vertical, 16)
                }//NavigationLink
            }//VStack
            .alert(isPresented: $viewModel.showAlert) {
                Alert(
                    title: Text("Error"),
                    message: Text(viewModel.errorMessage),
                    dismissButton: .default(Text("OK"))
                )
            }
            if viewModel.showLoadingSpinner {
                Color.black.opacity(0.4)
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    AuthProgressView()
                }
            }
        }//ZStack
    }
    
}

#Preview {
    RegistrationView()
}

extension UIApplication {
    func dismissKeyboard() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

//
//  ViewExtension.swift
//  Nexus
//
//  Created by BINAYA THAPA MAGAR on 2024-09-26.
//

import SwiftUI

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    func toast(isPresented: Binding<Bool>, message: String, duration: TimeInterval = 2.0) -> some View {
        ZStack {
            self
            if isPresented.wrappedValue {
                VStack {
                    Spacer() // Pushes the toast to the bottom
                    ToastView(message: message)
                        .transition(.opacity)
                        .padding(.bottom, 16) // Padding from the bottom of the screen
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                                isPresented.wrappedValue = false
                            }
                        }
                }
                .animation(.easeInOut, value: isPresented.wrappedValue) // Smooth transition in and out
            }
        }
    }
    
}

//
//  ToastView.swift
//  Nexus
//
//  Created by BINAYA THAPA MAGAR on 2024-10-09.
//

import SwiftUI

struct ToastView: View {
    let message: String
    
    var body: some View {
        Text(message)
            .font(.body)
            .padding()
            .background(Color.black.opacity(0.75))
            .foregroundColor(.white)
            .cornerRadius(10)
            .multilineTextAlignment(.center)
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 20)
    }
}

#Preview {
    ToastView(message: "This is a test toast message.")
}

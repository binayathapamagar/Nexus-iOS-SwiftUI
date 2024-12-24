//
//  TextFieldModifier.swift
//  Nexus
//
//  Created by BINAYA THAPA MAGAR on 2024-09-26.
//

import SwiftUI

struct TextFieldModifier: ViewModifier {
    
    func body(content: Content) -> some View {
        content
            .font(.subheadline)
            .padding()
            .background(Color(.systemGray6))
            .clipShape(
                RoundedRectangle(cornerRadius: 10)
            )
            .padding(.horizontal, 24)
    }
    
}

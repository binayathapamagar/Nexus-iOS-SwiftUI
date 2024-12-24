//
//  AuthButtonModifier.swift
//  Nexus
//
//  Created by BINAYA THAPA MAGAR on 2024-09-26.
//

import SwiftUI

struct AuthButtonModifier: ViewModifier {
    
    func body(content: Content) -> some View {
        content
            .font(.subheadline)
            .fontWeight(.semibold)
            .foregroundStyle(.appSecondary)
            .frame(maxWidth: .infinity, maxHeight: 40)
            .background(.appPrimary)
            .clipShape(
                RoundedRectangle(cornerRadius: 8)
            )
            .padding(.vertical)
            .padding(.horizontal, 24)
    }
    
}

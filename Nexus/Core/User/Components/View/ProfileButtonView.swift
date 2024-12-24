//
//  ProfileButtonView.swift
//  Nexus
//
//  Created by BINAYA THAPA MAGAR on 2024-12-05.
//

import SwiftUI

struct ProfileButtonView: View {
    var title: String
    
    var body: some View {
        Text(title)
            .font(.subheadline)
            .fontWeight(.semibold)
            .foregroundStyle(.appPrimary)
            .frame(maxWidth: .infinity, minHeight: 32)
            .background(.appSecondary)
            .clipShape(
                RoundedRectangle(cornerRadius: 8)
            )
            .overlay {
                RoundedRectangle(cornerRadius: 8)
                    .strokeBorder(Color(.systemGray4), lineWidth: 1)
            }
    }
}

#Preview {
    ProfileButtonView(title: "Edit profile")
}

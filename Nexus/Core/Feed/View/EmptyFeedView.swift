//
//  EmptyFeedView.swift
//  Nexus
//
//  Created by BINAYA THAPA MAGAR on 2024-11-25.
//

import SwiftUI

struct EmptyFeedView: View {
    @Binding var showExploreView: Bool
    
    var body: some View {
        VStack(alignment: .center, spacing: 16) {
            Text("What? No Threads yet?")
                .font(.headline)
                .fontWeight(.semibold)
            
            Text("This empty feed won't be around for long. Start following people and you'll see threads show up here.")
                .font(.footnote)
            
            Button {
                showExploreView = true
            } label: {
                Text("Find people to follow")
                    .foregroundStyle(.appSecondary)
                    .font(.footnote)
                    .fontWeight(.semibold)
                    .padding()
                    .background(
                        Capsule()
                    )
            }
        }//VStack
        .multilineTextAlignment(.center)
        .padding()
    }
}

#Preview {
    EmptyFeedView(showExploreView: .constant(false))
}

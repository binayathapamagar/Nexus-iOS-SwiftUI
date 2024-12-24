//
//  ContentView.swift
//  Nexus
//
//  Created by BINAYA THAPA MAGAR on 2024-09-26.
//

import SwiftUI


struct ContentView: View {
    @StateObject private var viewModel = ContentViewModel()
    
    var body: some View {
        Group {
            if viewModel.userSession != nil {
                TabBarView()
            } else {
                LoginView()
            }
        }//Group
        .onAppear {
            if viewModel.userSession != nil {
                print(#function, "New usersession...")
                let _ = UserService.shared
            }
        }
    }
}

#Preview {
    ContentView()
}

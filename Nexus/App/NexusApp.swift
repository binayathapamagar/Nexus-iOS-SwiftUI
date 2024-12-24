//
//  NexusApp.swift
//  Nexus
//
//  Created by BINAYA THAPA MAGAR on 2024-09-26.
//

import SwiftUI
import FirebaseCore
import Firebase

@main
struct NexusApp: App {
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onOpenURL { url in
                    DynamicLinks.dynamicLinks().handleUniversalLink(url) { dynamicLink, error in
                        if let dynamicLink = dynamicLink, let deepLink = dynamicLink.url {
                            print("Received deep link: \(deepLink)")
                        }
                    }
                }
        }
    }
    
}

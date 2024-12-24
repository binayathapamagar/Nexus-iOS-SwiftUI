//
//  RegistrationViewModel.swift
//  Nexus
//
//  Created by BINAYA THAPA MAGAR on 2024-09-26.
//

import Foundation

class RegistrationViewModel: ObservableObject {
    
    @Published var fullName = ""
    @Published var username = ""
    @Published var email = ""
    @Published var password = ""
    @Published var errorMessage: String = ""
    @Published var showAlert = false
    @Published var showLoadingSpinner = false
    
    var fieldsAreEmpty: Bool {
        fullName.isEmpty || username.isEmpty || email.isEmpty || password.isEmpty
    }
    
    @MainActor
    func createUser() async throws {
        showLoadingSpinner = true
        
        defer {
            // Must place before the do catch to register the defer. This will always run before exiting the function, stopping the spinner.
            showLoadingSpinner = false
        }
        
        do {
            try await AuthService.shared.createUser(
                withEmail: email,
                password: password,
                fullname: fullName,
                username: username
            )
        } catch {
            print(#function, "ERROR: Error registering the user with: \(error.localizedDescription)")
            errorMessage = error.localizedDescription
            showAlert = true
        }
    }
    
}

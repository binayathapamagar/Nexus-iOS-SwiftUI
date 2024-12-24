//
//  AuthService.swift
//  Nexus
//
//  Created by BINAYA THAPA MAGAR on 2024-09-26.
//

import FirebaseAuth
import FirebaseFirestore

class AuthService {
    
    // MARK: - Properties
    
    private let USERS_COLLECTION_NAME = "users"
    @Published var userSession: FirebaseAuth.User?
    
    static let shared = AuthService()
    
    // MARK: - Initializers
    
    init() {
        self.userSession = Auth.auth().currentUser //Will be nil if the user is not logged in.
    }
    
    // MARK: - FireAuth methods
    
    @MainActor
    func login(withEmail email: String, password: String) async throws {
        do {
            print(#function, "DEBUG: login() called...")
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            self.userSession = result.user
            print(#function, "DEBUG: Successfully login: \(result.user.uid)")

            try await UserService.shared.fetchCurrentUser()//Getting the latest user.
        } catch {
            print(#function, "DEBUG: Failed to login with error: \(error.localizedDescription)")
            throw error
        }
    }
    
    //Any time we have a function that has an asynce throws, we have to wrap it in a do catch block.
    @MainActor
    func createUser(withEmail email: String, password: String, fullname: String, username: String) async throws {
        print(#function, "DEBUG: createUser() called...")
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            self.userSession = result.user
            print(#function, "DEBUG: Successfully create a new user: \(result.user.uid)")
            
            try await uploadUserData(id: result.user.uid, email: email, fullname: fullname, username: username)
        } catch {
            print(#function, "DEBUG: Failed to create a new user with error: \(error.localizedDescription)")
            throw error
        }
    }
    
    func signOut() {
        print(#function, "DEBUG: signOut() called...")
        try? Auth.auth().signOut() //Signs the user on the Firebase backend
        userSession = nil //Signs the user out locally and updates the routing
        UserService.shared.resetCurrentUser()//Sets the current user to nil
    }
    
    // MARK: - Firestore collection methods
    
    @MainActor
    private func uploadUserData(
        id: String,
        email: String,
        fullname: String,
        username: String
    ) async throws {
        print(#function, "DEBUG: uploadUserData() called...")
        let user = User(
            id: id,
            username: username,
            fullName: fullname,
            email: email,
            joinedDate: Date.getJoinedAtDateString()
        )
        guard let userData = try? Firestore.Encoder().encode(user) else { return }
        try await Firestore.firestore().collection(USERS_COLLECTION_NAME).document(id).setData(userData)
        print(#function, "DEBUG: Successfully uploaded the user \(id) to the users collection.")
        
        UserService.shared.currentUser = user
    }
    
}

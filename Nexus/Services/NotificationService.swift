//
//  NotificationService.swift
//  Nexus
//
//  Created by BINAYA THAPA MAGAR on 2024-12-05.
//

import Firebase
import FirebaseAuth

struct NotificationService {
    
    private init() {}
    
    static func sendNotification(_ notification: Notification) async throws {
        guard let notificationData = try? Firestore.Encoder().encode(notification) else { return }
        
        let userNotificationRef = FirestoreConstants
            .NotificationCollection
            .document(notification.ownerId)
            .collection(FirestoreConstants.NotificationCollectionName)
        
        try await userNotificationRef.addDocument(data: notificationData)
    }
    
    static func fetchNotifications() async throws -> [Notification] {
        guard let currentUserUid = Auth.auth().currentUser?.uid else { return [] }

        let snapshot = try await FirestoreConstants
            .NotificationCollection
            .document(currentUserUid)
            .collection(FirestoreConstants.NotificationCollectionName)
            .order(by: FirestoreConstants.TimestampFieldName, descending: true)
            .getDocuments()
        
        return snapshot.documents.compactMap { try? $0.data(as: Notification.self) }
    }
}

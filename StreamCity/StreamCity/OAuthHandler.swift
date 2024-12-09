//
//  OAuthHandler.swift
//  StreamCity
//
//  Created by Noah Russell on 12/9/24.
//

import Firebase
import FirebaseFirestore

/// Saves an OAuth token to Firestore under a user's linked accounts collection.
func saveOAuthToken(platform: String, token: String, userId: String) {
    let db = Firestore.firestore()
    
    // Create or update the linked account document in Firestore.
    db.collection("users").document(userId).collection("linkedAccounts").document(platform).setData([
        "token": token,               // The OAuth token, should be encrypted in a real app.
        "linkedAt": FieldValue.serverTimestamp() // Timestamp for when the account was linked.
    ]) { error in
        if let error = error {
            // Log the error with detailed information for debugging.
            print("Error saving linked account for \(platform): \(error.localizedDescription)")
        } else {
            // Optionally, log a success message or use a more user-friendly notification.
            print("\(platform) account linked successfully!")
        }
    }
}

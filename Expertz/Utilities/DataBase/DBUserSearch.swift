//
//  DBUserSearch.swift
//  Expertz
//
//  Created by Ryan Loi on 2024-11-28.
//

import Firebase
import FirebaseFirestore

// Firebase helper function to check if a user exists in Firestore
func checkIfUserExists(userID: String, completion: @escaping (Bool) -> Void) {
    let db = Firestore.firestore()
    let userRef = db.collection("UserProfiles").document(userID)
    
    userRef.getDocument { document, error in
        DispatchQueue.main.async {
            if let document = document, document.exists {
                print("User exists")
                completion(true) // User exists
            } else {
                print("User does not exist")
                completion(false) // User does not exist
            }
        }
    }
}

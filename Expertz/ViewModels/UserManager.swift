//
//  UserManager.swift
//  Expertz
//
//  Created by Michelle Loi on 2024-11-29.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class UserManager: ObservableObject {
    @Published private(set) var currentUserId: String?
    
    // When we initalize the user manager it will get the user id for us this way
    // I don't need to fetch a bunch of times
    init() {
        self.currentUserId = getCurrentUserId()
    }
    
    
    /// Gets the current user's id
    /// - Returns: A string of the current user's id
    private func getCurrentUserId() -> String? {
        guard let currentUser = Auth.auth().currentUser else { return nil }
        return currentUser.uid
    }
    
    
    /// Gets the current users name
    /// - Parameter completion: the current users name
    func getCurrentUserName(completion: @escaping (String?) -> Void) {
        guard let currentUser = Auth.auth().currentUser else {
            completion(nil)
            return
        }

        let db = Firestore.firestore()
        let userDocRef = db.collection("UserProfiles").document(currentUser.uid)
        
        userDocRef.getDocument { document, error in
            if let document = document, document.exists {
                let data = document.data()
                let firstName = data?["firstName"] as? String ?? ""
                let lastName = data?["lastName"] as? String ?? ""
                
                let fullName = [firstName, lastName].filter { !$0.isEmpty }.joined(separator: " ")
                completion(fullName.isEmpty ? "Unknown" : fullName)
            } else {
                completion(nil)
            }
        }
    }

}

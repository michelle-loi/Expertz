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
    @Published var isExpert: Bool = false  // New published property to indicate expert status
    
    // When we initialize the user manager it will get the user id for us this way
    // I don't need to fetch a bunch of times.
    init() {
        self.currentUserId = getCurrentUserId()
        loadUserRole()  // Fetch the user role right away
    }
    
    /// Gets the current user's id.
    /// - Returns: A string of the current user's id.
    private func getCurrentUserId() -> String? {
        guard let currentUser = Auth.auth().currentUser else { return nil }
        return currentUser.uid
    }
    
    /// Loads the current user's role from Firestore and sets the isExpert property.
    func loadUserRole() {
        guard let uid = currentUserId else { return }
        let db = Firestore.firestore()
        db.collection("UserProfiles").document(uid).getDocument { document, error in
            if let document = document, document.exists,
               let data = document.data(),
               let expert = data["isExpert"] as? Bool {
                DispatchQueue.main.async {
                    self.isExpert = expert
                }
            } else {
                DispatchQueue.main.async {
                    self.isExpert = false
                }
                if let error = error {
                    print("Error loading user role: \(error.localizedDescription)")
                }
            }
        }
    }
    
    /// Gets the current user's name.
    /// - Parameter completion: the current user's name.
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

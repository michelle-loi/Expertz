//
//  UserManager.swift
//  Expertz
//
//  Created by Michelle Loi on 2024-11-29.
//

import Foundation
import FirebaseAuth

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
}

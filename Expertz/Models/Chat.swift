//
//  Chat.swift
//  Expertz
//
//  Created by Michelle Loi on 2024-11-26.
//

import Foundation

/**
 Identifiable: Allows the Chat to be identified by its id
 Codable: Allows conversion between swift structure and Firebase structure
 */
struct Chat: Identifiable, Codable {
    var id: String
    var participantIDs: [String]
    var participants: [String: String] // key is the id of type string, and value is the participants name of type string
    var lastMessage: String // Last message to show in the all messages view
    var lastMessageTimestamp: Date // Date to show the time the last message was sent
    
    
    /// Returns the recipient name of the chat (the other user)
    /// - Parameter userID: the id of the current user
    /// - Returns: the name of the recipient
    func getRecipientName(for userID: String) -> String? {
        return participants.first { $0.key != userID }?.value
    }
}

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
    var participants: [String]
    var recipientName: String
    var lastMessage: String // Last message to show in the all messages view
    var lastMessageTimestamp: Date // Date to show the time the last message was sent
}

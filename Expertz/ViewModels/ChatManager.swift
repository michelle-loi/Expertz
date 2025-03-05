//
//  ChatManager.swift
//  Expertz
//
//  Created by Michelle Loi on 2024-11-26.
//

import Foundation
import FirebaseFirestore

class ChatManager: ObservableObject {
    @Published private(set) var chats: [Chat] = [] // stores the list of chats for the user, private(set) makes it so it can only be modified within ChatManager
    @Published var isLoading: Bool = true // tracks whether data has been obtained yet
    
    private let db = Firestore.firestore()
    
    
    /// Fetches all the chats a user belongs to based on the parameter userId
    /// - Parameter userId: The user's id to fetch chats for
    func getChats(for userId: String) {
        db.collection("chats")
            .whereField("participantIDs", arrayContains: userId)
            //.whereField("participants.\(userId)", isGreaterThan: "")
            .order(by: "lastMessageTimestamp", descending: true) // order by newest chat first
            .addSnapshotListener { querySnapshot, error in
                
                // Check if the chats for the user was obtained otherwise exit and print the error
                guard let documents = querySnapshot?.documents else {
                    print("Error fetching documents: \(String(describing: error))")
                    return
                }
                
                // Get the chats
                let fetchedChats = documents.compactMap { document -> Chat? in
                    do {
                        return try document.data(as: Chat.self)
                    } catch {
                        print("Error decoding document into Chat: \(error)")
                        return nil
                    }
                }
            
                // Use main thread to prevent ui problems
                DispatchQueue.main.async {
                    self.chats = fetchedChats
                    self.isLoading = false
                }
        }
    }

    
    /// Creates a new chat between the sender and recipient
    /// - Parameters:
    ///   - chatId: The id to create the chat with
    ///   - senderId: The id of the sender of the chat
    ///   - senderName: The name of the sender
    ///   - recipientId: The id of the recipient of the chat
    ///   - recipientName: The name of the recipient  (for the all messages view)
    ///   - message: The message that was sent to create the chat
    ///   - completion: The closure to run once the function is finished creating a chat and making the messages
    private func createChat(
        chatId: String,
        senderId: String,
        senderName: String,
        recipientId: String,
        recipientName: String,
        message: String,
        completion: @escaping (Bool) -> Void
    ) {
        do {
            let newChat = Chat(
                id: chatId,
                participantIDs: [senderId, recipientId],
                participants: [
                    senderId: senderName,
                    recipientId: recipientName
                ],
                lastMessage: message,
                lastMessageTimestamp: Date()
            )

            let chatDoc = db.collection("chats").document(newChat.id)
            try chatDoc.setData(from: newChat)

            let firstMessage = Message(
                id: "\(UUID())",
                text: message,
                senderId: senderId,
                timestamp: Date()
            )

            // Create the messages subcollection
            try chatDoc.collection("messages").document(firstMessage.id).setData(from: firstMessage)

            completion(true)
            
        } catch {
            print("Error adding a chat to Firestore: \(error)")
            completion(false)
        }
    }

    
    /// Returns if a chat exists or not
    /// - Parameters:
    ///   - senderId: The id of the sender
    ///   - recipientId: The id of the recipient
    ///   - completion: Closure to run
    func checkChatExists(senderId: String, recipientId: String, completion: @escaping (Bool) -> Void) {
        // Create the chat id, the chat id puts the id that is smaller first
        // This prevents having two chats with the same people in different order
        // A_B and B_A for example
        let chatId = senderId < recipientId ? "\(senderId)_\(recipientId)" : "\(recipientId)_\(senderId)"
        let chatDoc = db.collection("chats").document(chatId)
        
        print("\(chatId)")
        
        chatDoc.getDocument { (document, error) in
            if error != nil {
                completion(false)
                return
            }
            
            print("check document existent")
            guard let document = document, document.exists else {
                completion(false)
                return
            }

            print("document existence")
            completion(true)
        }
    }
    
    /// Tries to create a new chat, but if one already exists for the two participants then it will not create a new chat
    /// - Parameters:
    ///   - senderId: The id of the sender
    ///   - senderName: The name of the sender
    ///   - recipientId: The id of the recipient
    ///   - recipientName: The recipient name
    ///   - message: The message to send
    ///   - completion: The closure to pass and run after the function finishes execution
    func createOrFetchChat(
        senderId: String,
        senderName: String,
        recipientId: String,
        recipientName: String,
        message: String,
        completion: @escaping (String?) -> Void
    ) {
        
        // Create the chat id, the chat id puts the id that is smaller first
        // This prevents having two chats with the same people in different order
        // A_B and B_A for example
        let chatId = senderId < recipientId ? "\(senderId)_\(recipientId)" : "\(recipientId)_\(senderId)"

        let chatDoc = db.collection("chats").document(chatId)

        chatDoc.getDocument { (document, error) in
            guard let document = document, document.exists else {
                // If we don't have a chat we can create one
                self.createChat(
                    chatId: chatId,
                    senderId: senderId,
                    senderName: senderName,
                    recipientId: recipientId,
                    recipientName: recipientName,
                    message: message
                ) { success in
                    if success {
                        // only return the id if we manage to create a chat
                        completion(chatId)
                    } else {
                        print("Error creating chat.")
                        completion(nil)
                    }
                }
                return
            }
            completion(chatId) // return id if the chat exists
        }
    }
}

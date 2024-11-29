//
//  MessagesManager.swift
//  Expertz
//
//  Created by Michelle Loi on 2024-11-26.
//

import Foundation
import FirebaseFirestore

class MessageManager: ObservableObject {
    @Published private(set) var messages: [Message] = [] // stores the retrieved messages

    private let db = Firestore.firestore()
    
    /// Gets all messages for a chat with the give chatId parameter
    /// - Parameter chatId: The id of the chat to retrieve messages for
    func getMessages(for chatId: String) {
        db.collection("chats")
            .document(chatId)
            .collection("messages")
            .order(by: "timestamp") // order by oldest to newest
            .addSnapshotListener { querySnapshot, error in
                guard let documents = querySnapshot?.documents else {
                    print("Error fetching documents: \(String(describing: error))")
                    return
                }
                
                let fetchedMessages = documents.compactMap { document -> Message? in
                    do {
                        return try document.data(as: Message.self)
                    } catch {
                        print("Error decoding document into Message: \(error)")
                        return nil
                    }
                }
                
                DispatchQueue.main.async {
                    self.messages = fetchedMessages
                }
            }
    }
    
    /// Takes the users sent message and adds it to the corresponding chat document with the chatId parameter
    /// - Parameters:
    ///   - text: The text within the sent message
    ///   - senderId: The id of the person who sent it
    ///   - chatId: The id of the chat this message belongs to
    func sendMessage(text: String, senderId: String, chatId: String) {
        do {
            let newMessage = Message(id: "\(UUID())", text: text, senderId: senderId, timestamp: Date())

            // Add message to the correct chat based on the chatId
            try db.collection("chats")
                .document(chatId)
                .collection("messages")
                .document(newMessage.id)
                .setData(from: newMessage)
            
//            print("Message sent successfully to chat \(chatId)")
        } catch {
            print("Error adding message to Firestore: \(error)")
        }
    }
}

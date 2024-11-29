//
//  Messages.swift
//  Expertz
//
//  Created by Ameriza on 2024-11-18.
//
//  Modified by Michelle
//  Code is based off of this tutorial and modified:
//  https://www.youtube.com/watch?v=Zz9XQy8PRpQ&t=1412s
//

import SwiftUI

struct Messages: View {
    @StateObject var chatManager = ChatManager()
    
    var body: some View {
        NavigationView {
            VStack(spacing: 10) {
                ForEach(chatManager.chats) { chat in
                    // Use the ChatBubble view here inside the Messages view
                    ChatBubble(
                        chatId: chat.id,
                        recipientName: chat.recipientName,
                        messagePreview: chat.lastMessage,
                        timestamp: chat.lastMessageTimestamp
                    )
                }
                Spacer()
            }
            .background(Theme.secondaryColor.ignoresSafeArea())
            .navigationTitle("Chats")
            .onAppear {
                // Fetch chats for the user right now it is a dummy string
                chatManager.getChats(for: "53Ex9GirPTtrZFv2BzeE") // change the id later
            }
        }
    }
}

struct ChatBubble: View {
    var chatId: String
    var recipientName: String
    var messagePreview: String
    var timestamp: Date
    
    
    /// Computes how much time has occured since the message was sent
    private var formattedTimestamp: String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .short
        return formatter.localizedString(for: timestamp, relativeTo: Date())
    }
    
    var body: some View {
        NavigationLink(destination: ChatRoom(chatId: chatId, recipientName: recipientName)) {
            VStack(alignment: .leading) {
                
                HStack {
                    // Recipient's name
                   Text(recipientName)
                       .font(.headline)
                       .foregroundColor(Theme.primaryColor)
                   
                   Spacer()
                   
                   // Timestamp
                   Text(formattedTimestamp)
                        .font(.footnote)
                       .foregroundColor(.gray) // Timestamp in gray color
               }
                
                // Message preview
                Text(messagePreview)
                    .font(.subheadline)
                    .foregroundColor(.black)
                    .lineLimit(1) // prevent wrapping truncate with ellipses
                    .truncationMode(.tail)
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Theme.accentColor)
            .cornerRadius(15)
            .shadow(radius: 1)
            .padding(.horizontal)
        }
    }
}

#Preview {
    Messages()
}

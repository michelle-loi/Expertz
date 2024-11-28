//
//  Messages.swift
//  Expertz
//
//  Created by Ameriza on 2024-11-18.
//

import SwiftUI

struct Messages: View {
    @StateObject var chatManager = ChatManager()
    
    var body: some View {
        VStack {
            Text("Chats")
                .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
        }
        .padding(.horizontal)
        .frame(maxWidth: .infinity, alignment: .leading)
        
        VStack(spacing: 10) {
            ForEach(chatManager.chats) { chat in
                // Use the ChatBubble view here inside the Messages view
                ChatBubble(
                    recipientName: chat.recipientName,
                    messagePreview: chat.lastMessage,
                    timestamp: chat.lastMessageTimestamp
                )
            }
            Spacer()
        }
        .background(Theme.secondaryColor.ignoresSafeArea())
        .onAppear {
            // Fetch chats for the user right now it is a dummy string
            chatManager.getChats(for: "53Ex9GirPTtrZFv2BzeE") // change the id later
        }
    }
}

struct ChatBubble: View {
    var recipientName: String
    var messagePreview: String
    var timestamp: Date
    
    private var formattedTimestamp: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a" // For example: "12:30 PM"
        return formatter.string(from: timestamp)
    }
    
    var body: some View {
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

#Preview {
    Messages()
}

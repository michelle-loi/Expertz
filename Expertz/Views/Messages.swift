
//  Code is based off of this tutorial and modified:
//  https://www.youtube.com/watch?v=Zz9XQy8PRpQ&t=1412s
//

import SwiftUI
import FirebaseAuth

struct Messages: View {
    @StateObject private var chatManager = ChatManager()
    @StateObject private var userManager = UserManager()
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .top){
                Color.clear
                    .background(.ultraThinMaterial)
                    .overlay(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                Color(red: 0.00, green: 0.90, blue: 0.90),
                                Color(red: 0.00, green: 0.90, blue: 0.90)
                            ]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                        .opacity(0.3)
                    )
                    .ignoresSafeArea()
                VStack(spacing: 10) {
                    ForEach(chatManager.chats) { chat in
                        if let currentUserId = userManager.currentUserId {
                            ChatBubble(
                                chatId: chat.id,
                                recipientName: chat.getRecipientName(for: currentUserId) ?? "",
                                messagePreview: chat.lastMessage,
                                timestamp: chat.lastMessageTimestamp
                            )
                        } else {
                        }
                    }
                    Spacer()
                }
                .navigationTitle("Chats")
                .onAppear {
                    // Fetch chats for the user right now it is a dummy string
                    chatManager.getChats(for: userManager.currentUserId ?? "")
                }
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

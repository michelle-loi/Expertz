//
//  ChatRoom.swift
//  Expertz
//
//  Created by Michelle Loi on 2024-11-28.
//

import SwiftUI

struct ChatRoom: View {
    var chatId: String
    var recipientName: String
    
    var body: some View {
        // Your detailed chat page content
        Text("Chat Details for \(chatId)")
            .navigationTitle(recipientName)
            .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    ChatRoom(chatId: "53Ex9GirPTtrZFv2BzeE", recipientName: "John Doe")
}

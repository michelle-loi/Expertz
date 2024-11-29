//
//  ChatRoom.swift
//  Expertz
//
//  Created by Michelle Loi on 2024-11-28.
//
//  Code is based off of this tutorial and modified: 
//  https://www.youtube.com/watch?v=Zz9XQy8PRpQ&t=1412s
//

import SwiftUI

struct ChatRoom: View {
    var chatId: String
    var recipientName: String
    var messageArray = ["Hello", "How are you doing?", "“Acts of goodness are not always wise, and acts of evil are not always foolish, but regardless, we shall always strive to be good.”"]
    
    var body: some View {
        VStack {
            VStack {
                TitleRow(recipientName: recipientName)
                    .background(Color(Theme.accentColor))
                    .padding(.top, 0)
                
                ScrollView {
                    ForEach(messageArray, id: \.self) { text in
                        MessageBubble(message: Message(id: "12345", text: text, senderId:"53Ex9GirPTtrZFv2BzeE", timestamp: Date()))
                    }
                }
                .padding(10)
                .background(.white)
                .cornerRadius(30, corners: [.topLeft, .topRight])
            }
            .background(Color(Theme.accentColor))
            // These two lines prevent the back button from adding too much padding
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarHidden(false)
            
            MessageField()
        }
    }
}

struct TitleRow: View {
    var recipientName: String
    
    var body: some View {
        HStack(spacing: 20) {
            Image("Expertz_Logo")
                .resizable()
                .aspectRatio(contentMode: /*@START_MENU_TOKEN@*/.fill/*@END_MENU_TOKEN@*/)
                .frame(width: 50, height: 50)
                .cornerRadius(50)
                .background(
                    Circle()
                        .fill(Color.white)
                )
                .overlay(
                    Circle()
                        .stroke(Theme.primaryColor, lineWidth: 2)
                        
                )
        
            VStack(alignment: .leading) {
                Text(recipientName)
                    .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/.bold())
            }
            .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .leading)
        }
        .padding()
    }
}

struct MessageBubble: View {
    var message: Message
    
    // Get the actual logged in users id later
    var dummyUserID: String = "53Ex9GirPTtrZFv2BzeE"
    
    // Controls tapping of the message bubble to show the time
    @State private var showTime = false
    
    /// Formats the provided date to show the localized and shorten version of the date along with the time
    /// - Parameter date: The date to format
    /// - Returns: The formatted date as a string
    func formattedTimestamp(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        
        return formatter.string(from: date)
    }
    
    var body: some View {
        // Trailing puts it to the right for the sender and leading to the left
        VStack(alignment: message.senderId == dummyUserID ? .trailing : .leading) {
            HStack {
                Text(message.text)
                    .padding()
                    .background(message.senderId == dummyUserID ? Color(Theme.accentColor) : Color(.systemGray5))
                    .cornerRadius(30)
            }
            .frame(maxWidth: 300, alignment: message.senderId == dummyUserID ? .trailing : .leading)
            .onTapGesture {
                showTime.toggle()
            }
            
            if showTime {
                Text(formattedTimestamp(date: message.timestamp))
                    .font(.caption2)
                    .foregroundColor(.gray)
                    .padding(message.senderId == dummyUserID ? .trailing : .leading, 20)
            }
            
        }
        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: message.senderId == dummyUserID ? .trailing : .leading)
        .padding(message.senderId == dummyUserID ? .trailing : .leading)
        .padding(.horizontal, 10)
    }
}

struct MessageField: View {
    @State private var message = ""
    
    var body: some View {
        HStack {
            CustomTextField(placeholder: Text("Message"), text: $message)
            
            Button {
                print("Message sent!")
                message = ""
                
            } label: {
                Image(systemName: "paperplane.fill")
                    .foregroundColor(.white)
                    .padding(10)
                    .background(Color(Theme.accentColor))
                    .cornerRadius(50)
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 10)
        .background(Color(.systemGray5))
        .cornerRadius(50)
        .padding()
    }
}

struct CustomTextField: View {
    var placeholder: Text
    @Binding var text: String // binding can pass variable from one view to another and modify it
    var editingChanged: (Bool) -> () = {_ in}
    var commit: () -> () = {}
    
    var body: some View {
        ZStack(alignment: .leading){
            if text.isEmpty {
                placeholder
                    .opacity(0.5)
            }
            TextField("", text: $text, onEditingChanged: editingChanged, onCommit: commit)
        }
    }
}

#Preview {
    ChatRoom(chatId: "53Ex9GirPTtrZFv2BzeE", recipientName: "John Doe")
}

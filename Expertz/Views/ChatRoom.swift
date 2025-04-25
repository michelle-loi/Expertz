//  Created by Michelle Loi on 2024-11-28.
//  Code is based off of this tutorial and modified:
//  https://www.youtube.com/watch?v=Zz9XQy8PRpQ&t=1412s
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct ChatRoom: View {
    var chatId: String
    var recipientName: String
    
    @StateObject private var messageManager = MessageManager()
    @StateObject private var userManager = UserManager()
    
    @State private var negotiatedPrice: Double? = nil
    @State private var confirmed: Bool = false    
    @State private var paid: Bool = false
    @State private var priceInput: String = ""
    @State private var showPaymentSheet: Bool = false
    
    @State private var clientJobCompleted: Bool = false
    @State private var expertJobCompleted: Bool = false
    @State private var showRatingSheet: Bool = false
    
    @State private var negotiationListener: ListenerRegistration? = nil
    
    var body: some View {
        VStack {
            VStack {
                TitleRow(recipientName: recipientName)
                    .background(Color(Theme.accentColor))
                    .padding(.top, 0)
                
                ScrollViewReader { proxy in
                    ScrollView {
                        if messageManager.messages.isEmpty {
                            Text("😔")
                                .font(.system(size: 50))
                                .padding(.bottom, -10)
                            Text("No messages yet")
                                .foregroundColor(.gray)
                                .padding()
                                .frame(maxWidth: .infinity)
                        } else {
                            ForEach(messageManager.messages, id: \.id) { message in
                                MessageBubble(message: message, currentUserId: userManager.currentUserId ?? "53Ex9GirPTtrZFv2BzeE")
                            }
                        }
                    }
                    .padding(10)
                    .background(.white)
                    .cornerRadius(30, corners: [.topLeft, .topRight])
                    .onChange(of: messageManager.lastMessageId) { _, newId in
                        withAnimation { proxy.scrollTo(newId, anchor: .bottom) }
                    }
                }
            }
            .background(Color(Theme.accentColor))
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                messageManager.getMessages(for: chatId)
                startNegotiationListener()
            }
            .onDisappear {
                negotiationListener?.remove()
            }
            
            VStack {
                if userManager.isExpert {
                    // Expert’s UI: Initially show the price input field until a price is proposed.
                    if negotiatedPrice == nil {
                        HStack {
                            TextField("Enter price proposal", text: $priceInput)
                                .keyboardType(.decimalPad)
                                .customFormInputField()
                            Button("Send Price") {
                                if let price = Double(priceInput) {
                                    updateNegotiation(price: price, confirmed: false, paid: false)
                                }
                            
                            }
                            .padding()
                            .background(Theme.accentColor)
                            .foregroundColor(.white)
                            .cornerRadius(30)
                        }
                        .padding()
                    } else {
                        // After proposal: Expert sees "Awaiting payment" until client confirms and pays.
                        if paid {
                            Text("")
                                .padding()
                        } else {
                            Text("Awaiting payment")
                                .padding()
                                .foregroundColor(.orange)
                        }
                    }
                } else {
                    // Client’s UI: When a price proposal exists and is not confirmed, show proposed price and "Confirm" button.
                    if let price = negotiatedPrice, !confirmed {
                        HStack {
                            Text("Expert proposes: $\(price, specifier: "%.2f")")
                                .padding()
                            Button("Confirm") {
                                updateNegotiation(price: price, confirmed: true, paid: false)
                                showPaymentSheet = true
                            }
                            .padding()
                            .background(Theme.primaryColor)
                            .foregroundColor(.white)
                            .cornerRadius(30)
                        }
                        .padding()
                    } else if let _ = negotiatedPrice, confirmed, paid {
                        Text("")
                            .padding()
                    }
                }
            }
            
            if paid {
                // Show job completion confirmation buttons if the job isn't fully confirmed by both parties.
                if !((userManager.isExpert && expertJobCompleted) || (!userManager.isExpert && clientJobCompleted)) {
                    Text("")
                        .padding()
                        .foregroundColor(.orange)
                    Button("Job Completed?") {
                        updateJobCompletion()
                    }
                    .padding()
                    .background(Theme.primaryColor)
                    .foregroundColor(.white)
                    .cornerRadius(30)
                    
                } else {
                    Text("")
                }
                
                // Once both sides confirm job completion, display "Leave a Rating" button.
                if clientJobCompleted && expertJobCompleted {
                    Button("Leave a Rating!") {
                        showRatingSheet = true
                    }
                    .padding()
                    .background(Theme.primaryColor)
                    .foregroundColor(.white)
                    .cornerRadius(30)
                }
            }
            
            MessageField(chatId: chatId, currentUserId: userManager.currentUserId ?? "53Ex9GirPTtrZFv2BzeE")
                .environmentObject(messageManager)
        }
        .sheet(isPresented: $showPaymentSheet) {
            PaymentView(negotiatedPrice: negotiatedPrice ?? 0.0, onPaymentSuccess: {
                if let price = negotiatedPrice {
                    updateNegotiation(price: price, confirmed: true, paid: true)
                }
            })
        }
        // Rating sheet presented when "Leave a Rating" is tapped.
        .sheet(isPresented: $showRatingSheet) {
            RatingView(recipientName: recipientName, fromUserId: userManager.currentUserId ?? "", onRatingSubmitted: {
                print("Rating submitted.")
                showRatingSheet = false
            })
        }

    }
    
    private func startNegotiationListener() {
        let chatDocRef = Firestore.firestore().collection("chats").document(chatId)
        negotiationListener = chatDocRef.addSnapshotListener { snapshot, error in
            guard let data = snapshot?.data() else { return }
            negotiatedPrice = data["negotiatedPrice"] as? Double
            confirmed = data["confirmed"] as? Bool ?? false
            paid = data["paid"] as? Bool ?? false
            clientJobCompleted = data["clientJobCompleted"] as? Bool ?? false
            expertJobCompleted = data["expertJobCompleted"] as? Bool ?? false
        }
    }
    
    private func updateNegotiation(price: Double?, confirmed: Bool, paid: Bool) {
        let chatDocRef = Firestore.firestore().collection("chats").document(chatId)
        var updates: [String: Any] = [
            "confirmed": confirmed,
            "paid": paid,
            "timestamp": Date()
        ]
        if let price = price {
            updates["negotiatedPrice"] = price
        }
        chatDocRef.updateData(updates) { error in
            if let error = error {
                print("Error updating negotiation: \(error.localizedDescription)")
            } else {
                print("Negotiation updated successfully.")
            }
        }
    }
    
    private func updateJobCompletion() {
        let chatDocRef = Firestore.firestore().collection("chats").document(chatId)
        var updates: [String: Any] = [
            "timestamp": Date()
        ]
        if userManager.isExpert {
            updates["expertJobCompleted"] = true
        } else {
            updates["clientJobCompleted"] = true
        }
        chatDocRef.updateData(updates) { error in
            if let error = error {
                print("Error updating job completion: \(error.localizedDescription)")
            } else {
                print("Job completion updated successfully.")
            }
        }
    }
}


struct TitleRow: View {
    var recipientName: String
    var body: some View {
        HStack(spacing: 20) {
            Image("Expertz_Logo")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 50, height: 50)
                .cornerRadius(50)
                .background(Circle().fill(Color.white))
                .overlay(Circle().stroke(Theme.primaryColor, lineWidth: 2))
            VStack(alignment: .leading) {
                Text(recipientName)
                    .font(.title.bold())
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding()
    }
}

struct MessageBubble: View {
    var message: Message
    var currentUserId: String
    @State private var showTime = false
    
    func formattedTimestamp(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
    
    var body: some View {
        VStack(alignment: message.senderId == currentUserId ? .trailing : .leading) {
            HStack {
                Text(message.text)
                    .padding()
                    .background(message.senderId == currentUserId ? Color(Theme.accentColor) : Color(.systemGray5))
                    .cornerRadius(30)
            }
            .frame(maxWidth: 300, alignment: message.senderId == currentUserId ? .trailing : .leading)
            .onTapGesture { showTime.toggle() }
            if showTime {
                Text(formattedTimestamp(date: message.timestamp))
                    .font(.caption2)
                    .foregroundColor(.gray)
                    .padding(message.senderId == currentUserId ? .trailing : .leading, 20)
            }
        }
        .frame(maxWidth: .infinity, alignment: message.senderId == currentUserId ? .trailing : .leading)
        .padding(message.senderId == currentUserId ? .trailing : .leading)
        .padding(.horizontal, 10)
    }
}

struct MessageField: View {
    var chatId: String
    var currentUserId: String
    
    @EnvironmentObject var messageManager: MessageManager
    @State private var message = ""
    
    var body: some View {
        HStack {
            CustomTextField(placeholder: Text("Message"), text: $message)
            Button {
                if !message.isEmpty {
                    messageManager.sendMessage(text: message, senderId: currentUserId, chatId: chatId)
                    message = ""
                }
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
    @Binding var text: String
    var editingChanged: (Bool) -> () = { _ in }
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


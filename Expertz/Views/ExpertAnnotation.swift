//
//  ExpertAnnotation.swift
//  Expertz
//
//  Created by Alan Huynh on 2024-11-29.
//

import SwiftUI

struct ExpertAnnotation: View {
    let annotation: MapBubble
    @Binding var selectedAnnotation: MapBubble?
    
    @Binding var navigateToChatroom: Bool
    @Binding var outerChatId: String
    @Binding var outerRecipientName: String
    
    @StateObject private var userManager = UserManager()
    @StateObject private var chatManager = ChatManager()
    
    @State private var expertRequest: String = ""

    var body: some View {
        VStack {
            Spacer()
            VStack(spacing: 10) {
                HStack(spacing: 10) {
                    Circle()
                        .fill(Color.gray)
                        .frame(width: 50, height: 50)

                    // Naming Section:
                    VStack(alignment: .leading) {
                        Text("\(annotation.name),")
                            .font(.headline)
                            .foregroundColor(Theme.primaryColor)
                        Text("Expertise:")
                            .font(.headline)
                            .foregroundColor(Theme.primaryColor)
                        Text("\(annotation.expertise ?? "N/A")")
                            .font(.headline)
                            .foregroundColor(Theme.accentColor)
                    }
                    Spacer()
                    
                    // Rating
                    HStack(spacing: 5) {
                        Text("\(annotation.rating)")
                            .font(.headline)
                            .foregroundColor(.black)
                        Circle()
                            .fill(Color.yellow)
                            .frame(width: 20, height: 20)
                    }
                }
                
                // Bio Section
                Text("\(annotation.bio ?? "Bio not available")")
                    .font(.body)
                    .foregroundColor(Theme.primaryColor)
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
                HStack(spacing: 10) {
                    ForEach(["Realism", "3D Design", "Unity"], id: \.self) { tag in
                        Text(tag)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(Theme.accentColor.opacity(0.2))
                            .foregroundColor(Theme.primaryColor)
                            .cornerRadius(30)
                    }
                }
                VStack(alignment: .leading, spacing: 10){
                    Text("Description")
                        .font(.headline)
                        .foregroundColor(Theme.primaryColor)
                    
                    Text("\(annotation.description ?? "No description available.")")
                        .font(.body)
                        .foregroundColor(Theme.primaryColor)
                        .multilineTextAlignment(.leading)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }

                HStack(){
                    Text("Rate: ")
                        .font(.headline)
                        .foregroundColor(Theme.primaryColor)
                    
                    Text("\(annotation.price ?? "No price available.")")
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Theme.accentColor.opacity(0.2))
                        .foregroundColor(Theme.primaryColor)
                        .cornerRadius(30)
                    Spacer()
                }
                
                HStack(){
                    Text("Location: ")
                        .font(.headline)
                        .foregroundColor(Theme.primaryColor)
                    
                    if annotation.inPerson == "Yes" {
                        Text("InPerson")
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(Theme.accentColor.opacity(0.2))
                            .foregroundColor(Theme.primaryColor)
                            .cornerRadius(30)
                    }

                    if annotation.inPerson == "Only" {
                        Text("InPerson - Only")
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(Theme.accentColor.opacity(0.2))
                            .foregroundColor(Theme.primaryColor)
                            .cornerRadius(30)
                    }
                    
                    if annotation.online == "Yes" {
                        Text("Online")
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(Theme.accentColor.opacity(0.2))
                            .foregroundColor(Theme.primaryColor)
                            .cornerRadius(30)
                    }
                    if annotation.online == "Only" {
                        Text("Online - Only")
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(Theme.accentColor.opacity(0.2))
                            .foregroundColor(Theme.primaryColor)
                            .cornerRadius(30)
                    }
                    Spacer()
                }
                
                VStack(alignment: .leading, spacing: 10) {
                    Text("Reviews:")
                        .font(.headline)
                        .foregroundColor(Theme.primaryColor)

                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 15) {
                            ForEach(0..<5) { index in
                                VStack(alignment: .leading) {
                                    Text("Lorem ipsum dolor sit amet.")
                                        .font(.body)
                                        .foregroundColor(Theme.primaryColor)
                                }
                                .padding()
                                .frame(width: 200)
                                .background(Theme.accentColor.opacity(0.2))
                                .cornerRadius(30)
                            }
                        }
                    }
                }
                TextField("Give a brief description", text: $expertRequest)
                    .padding()
                    .background(Theme.accentColor.opacity(0.2))
                    .foregroundColor(Theme.primaryColor)
                    .cornerRadius(30)
                Button(action: {
                    selectedAnnotation = nil
                    print("\(annotation.id)")
                    print("Expert Request: \(expertRequest)")
                    chatManager.createOrFetchChat(senderId: userManager.currentUserId ?? "", recipientId: annotation.id, recipientName: annotation.name, message: expertRequest) { chatId in
                        if let chatId = chatId {
                            DispatchQueue.main.async {
                                print("\(chatId)")
                                navigateToChatroom = true
                                outerChatId = chatId
                                outerRecipientName = annotation.name
                            }
                        }
                    }
                }) {
                    Text("Send a request")
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Theme.accentColor)
                        .cornerRadius(30)
                }
            }
            .padding()
            .background(Color.white)
            .cornerRadius(30)
            .shadow(radius: 50)
            .padding(.horizontal, 20)
            Spacer(minLength: 5)
        }
    }
}

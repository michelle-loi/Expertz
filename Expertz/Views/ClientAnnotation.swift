//
//  ClientAnnotation.swift
//  Expertz
//
//  Created by Alan Huynh on 2024-11-29.
//  Edited  by Michelle
//
//  - Nested View Component for AnnotationDetails View
//  - Pulling parameters from AnnotationDetails to populate view body
//  - Client Annotation of Client Bubbles on Map
//  - Logic to trigger dynamnic chat between two users based on client request
//

import SwiftUI

struct ClientAnnotation: View {
    let annotation: MapBubble
    @Binding var selectedAnnotation: MapBubble?
    @Binding var navigateToChatroom: Bool
    @Binding var outerChatId: String
    @Binding var outerRecipientName: String

    
    @StateObject private var userManager = UserManager()
    @StateObject private var chatManager = ChatManager()
    
    @State private var clientRequest: String = ""
    @State private var chatExists: Bool? = nil

    var body: some View {
        VStack {
            Spacer()
            VStack(spacing: 10) {
                
                // Client Name and Rating Section
                HStack(spacing: 10) {
                    Circle()
                        .fill(Color.gray)
                        .frame(width: 50, height: 50)

                    VStack(alignment: .leading) {
                        Text("\(annotation.name),")
                            .font(.headline)
                            .foregroundColor(Theme.primaryColor)
                        Text("Needs help with:")
                            .font(.headline)
                            .foregroundColor(Theme.primaryColor)
                        Text("\(annotation.help ?? "N/A")")
                            .font(.headline)
                            .foregroundColor(Theme.accentColor)
                    }
                    Spacer()
                    HStack(spacing: 5) {
                        Text("\(annotation.rating)")
                            .font(.headline)
                            .foregroundColor(.black)
                        Circle()
                            .fill(Color.yellow)
                            .frame(width: 20, height: 20)
                    }
                }
                
                // Client Request Description
                Text("\(annotation.description ?? "No description available.")")
                    .font(.body)
                    .foregroundColor(Theme.primaryColor)
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                // Client Request Urgency
                HStack {
                    Text("Urgency: ")
                    if annotation.urgent == "No" {
                        Text("No")
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(Theme.accentColor.opacity(0.2))
                            .foregroundColor(Theme.primaryColor)
                            .cornerRadius(30)
                    } else if annotation.urgent == "Yes" {
                        Text("Yes")
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(Theme.accentColor.opacity(0.2))
                            .foregroundColor(Theme.primaryColor)
                            .cornerRadius(30)
                    }
                    Spacer()
                }
                
                // Client Request Price and Negotiable fields
                HStack {
                    Text("Price: ")
                    Text("\(annotation.price ?? "No price available.")")
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Theme.accentColor.opacity(0.2))
                        .foregroundColor(Theme.primaryColor)
                        .cornerRadius(30)

                    if annotation.negotiable == "Yes" {
                        Text("Negotiable")
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(Theme.accentColor.opacity(0.2))
                            .foregroundColor(Theme.primaryColor)
                            .cornerRadius(30)
                    }
                    Spacer()
                }
                
                // Client request Location Information
                HStack {
                    Text("Location: ")
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
                
                // Chat Logic
                if let chatExists = chatExists {
                    if (chatExists) {
                        let chatId = userManager.currentUserId ?? "" < annotation.id ? "\(userManager.currentUserId ?? "")_\(annotation.id)" : "\(annotation.id)_\(userManager.currentUserId ?? "")"
                        Button(action: {
                            navigateToChatroom = true
                            outerChatId = chatId
                            outerRecipientName = annotation.name
                        }) {
                            Text("Go to chat!")
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Theme.accentColor)
                                .cornerRadius(30)
                        }
                    } else {
                        TextField("How much are you charging for this work?", text: $clientRequest)
                            .padding()
                            .background(Theme.accentColor.opacity(0.2))
                            .foregroundColor(Theme.primaryColor)
                            .cornerRadius(30)
                        
                        Button(action: {
                            if !clientRequest.isEmpty {
                                selectedAnnotation = nil
                                print("\(annotation.id)")
                                print("Client Request: \(clientRequest)")
                                chatManager.createOrFetchChat(senderId: userManager.currentUserId ?? "", recipientId: annotation.id, recipientName: annotation.name, message: clientRequest) { chatId in
                                    if let chatId = chatId {
                                        DispatchQueue.main.async {
                                            navigateToChatroom = true
                                            outerChatId = chatId
                                            outerRecipientName = annotation.name
                                        }
                                    }
                                }
                            }
                        }) {
                            Text("Notify the client")
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Theme.accentColor)
                                .cornerRadius(30)
                        }
                    }
                }
            }
            .padding()
            .background(Color.white)
            .cornerRadius(30)
            .shadow(radius: 10)
            .padding(.horizontal, 20)
            Spacer(minLength: 5)
        }
        .onAppear {
            // Call the checkChatExists function when the view appears
            chatManager.checkChatExists(senderId: userManager.currentUserId ?? "", recipientId: annotation.id) { exists in
                // Update the state after the asynchronous check is done
                DispatchQueue.main.async {
                    chatExists = exists
                }
            }
        }
    }
}

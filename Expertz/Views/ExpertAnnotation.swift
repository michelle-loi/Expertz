//
//  ExpertAnnotation.swift
//  Expertz
//
//  Created by Alan Huynh on 2024-11-29.
//  Edited  by Michelle
//
//  - Nested View Component for AnnotationDetails View
//  - Pulling parameters from AnnotationDetails to populate view body
//  - Expert Annotation of Client Bubbles on Map
//  - Logic to trigger dynamnic chat between two users based on client request
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
    @State private var chatExists: Bool? = nil

    var body: some View {
        VStack {
            Spacer()
            VStack(spacing: 10) {
                HStack(spacing: 10) {
                    Circle()
                        .fill(Color.gray)
                        .frame(width: 50, height: 50)

                    // Expert Name, Expertise, and Rating Section:
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

//                // Bio Section - To be implement later on
//                Text("\(annotation.bio ?? "Bio not available")")
//                    .font(.body)
//                    .foregroundColor(Theme.primaryColor)
//                    .multilineTextAlignment(.leading)
//                    .frame(maxWidth: .infinity, alignment: .leading)
//                HStack(spacing: 10) {
//                    ForEach(["Realism", "3D Design", "Unity"], id: \.self) { tag in
//                        Text(tag)
//                            .padding(.horizontal, 12)
//                            .padding(.vertical, 6)
//                            .background(Theme.accentColor.opacity(0.2))
//                            .foregroundColor(Theme.primaryColor)
//                            .cornerRadius(30)
//                    }
//                }
                
                // Description Section
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

                // Pricing Section
                HStack(){
                    Text("Rate: ")
                        .font(.headline)
                        .foregroundColor(Theme.primaryColor)
                    
                    Text("\(annotation.price ?? "No price available.")")
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Theme.primaryColor)
                        .foregroundColor(Theme.secondaryColor)
                        .cornerRadius(30)
                    Spacer()
                }
                
                // Review Section - To be implemented (Currently hardcoded
                VStack(alignment: .leading, spacing: 10) {
                    Text("Reviews")
                        .font(.headline)
                        .foregroundColor(Theme.primaryColor)

                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 15) {
                            ForEach(0..<5) { index in
                                VStack(alignment: .leading) {
                                    Text("Lorem ipsum dolor sit amet.")
                                        .font(.body)
                                        .foregroundColor(Theme.secondaryColor)
                                }
                                .padding()
                                .frame(width: 200)
                                .background(Theme.primaryColor)
                                .cornerRadius(30)
                            }
                        }
                    }
                }
                
                // Availability Section
                HStack(){
                    Text("Availability: ")
                        .font(.headline)
                        .foregroundColor(Theme.primaryColor)
                    
                    if annotation.inPerson == "Yes" {
                        Text("InPerson")
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(Theme.primaryColor)
                            .foregroundColor(Theme.secondaryColor)
                            .cornerRadius(30)
                    }

                    if annotation.inPerson == "Only" {
                        Text("InPerson - Only")
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(Theme.primaryColor)
                            .foregroundColor(Theme.secondaryColor)
                            .cornerRadius(30)
                    }
                    
                    if annotation.online == "Yes" {
                        Text("Online")
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(Theme.primaryColor)
                            .foregroundColor(Theme.secondaryColor)
                            .cornerRadius(30)
                    }
                    if annotation.online == "Only" {
                        Text("Online - Only")
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(Theme.primaryColor)
                            .foregroundColor(Theme.secondaryColor)
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
                        TextField("Give a brief description", text: $expertRequest)
                            .padding()
                            .font(Theme.inputFont.bold())
                            .frame(maxWidth: .infinity)
                            .background(.ultraThinMaterial)
                            .foregroundColor(Theme.primaryColor)
                            .cornerRadius(30)
                            .overlay(
                                RoundedRectangle(cornerRadius: 30)
                                    .stroke(Theme.primaryColor, lineWidth: 2)
                            )
                        Button(action: {
                            if !expertRequest.isEmpty {
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
                            }
                        }) {
                            Text("Send a request")
                                .font(Theme.inputFont.bold())
                                .frame(maxWidth: .infinity)
                                .padding()     .background(Theme.primaryColor)
                                .foregroundColor(Theme.secondaryColor)
                                .cornerRadius(30)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 30)
                                        .stroke(Theme.primaryColor, lineWidth: 2)
                                )
                        }
                    }
                }
            }
            .padding()
            .background(.ultraThinMaterial)
            .cornerRadius(30)
            .overlay(
                RoundedRectangle(cornerRadius: 30)
                    .stroke(Theme.primaryColor, lineWidth: 2)
            )
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

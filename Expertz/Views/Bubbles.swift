//
//  Bubbles.swift
//  Expertz
//
//  Created by Mark on 2024-11-26.
//
import SwiftUI

struct Bubbles: View {
    @State private var isUrgent = false // State for dark mode toggle
    @State private var isNegotiable = false // State for dark mode toggle

    @Binding var annotation: MapBubble // Pass the binding from the parent
    @Binding var selectedAnnotation: MapBubble?
    var body: some View {
        ZStack {
            // Dark background overlay
            Rectangle()
                .fill(Color.black.opacity(0.6))
                .ignoresSafeArea()
                .onTapGesture {
                    selectedAnnotation = nil // Close popup
                }
                .zIndex(0) // Ensure it's below the popup content
            
            // Popup content
            if annotation.type == "Expert" {
                VStack {
                    Spacer()
                    VStack(spacing: 10) {
                        // Profile Section
                        HStack(spacing: 10) {
                            // Profile Picture Placeholder
                            Circle()
                                .fill(Color.gray)
                                .frame(width: 50, height: 50)
                            
                            VStack(alignment: .leading) {
                                Text("\(annotation.name),")
                                    .font(.headline)
                                    .foregroundColor(Theme.primaryColor)
                                Text("An Expert in:")
                                    .font(.headline)
                                    .foregroundColor(Theme.primaryColor)
                                Text("\(annotation.expertise ?? "N/A")")
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
                                    .frame(width: 20, height: 20) // Star icon placeholder
                            }
                        }
                        
                        // Description
                        Text("\(annotation.bio ?? "Bio not available")")
                            .font(.body)
                            .foregroundColor(Theme.primaryColor)
                            .multilineTextAlignment(.leading)
                            .frame(maxWidth: .infinity, alignment: .leading) // Avoid large height
                        
                        // Tags
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
                        
                        // Reviews Section
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
                        
                        // Description Text Field
                        TextField("Give a brief description", text: .constant(""))
                            .padding()
                            .background(Theme.accentColor.opacity(0.2))
                            .foregroundColor(Theme.primaryColor)
                            .cornerRadius(30)
                        
                        // Send Request Button
                        Button(action: {
                            selectedAnnotation = nil
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
                .zIndex(1) // Ensure popup is above the background overlay
            }
            if annotation.type == "Client" {
                VStack {
                    Spacer() // Push content to the bottom
                    VStack(spacing: 10) {
                        // Profile Section
                        HStack(spacing: 10) {
                            // Profile Picture Placeholder
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
                                    .frame(width: 20, height: 20) // Star icon placeholder
                            }
                        }
                        
                        // Description
                        Text("\(annotation.description ?? "No description available.")")
                            .font(.body)
                            .foregroundColor(Theme.primaryColor)
                            .multilineTextAlignment(.leading)
                            .frame(maxWidth: .infinity, alignment: .leading) // Avoid large height
                        
                        // Tags
                        HStack() {
                            Text("Urgency: ")
                            if annotation.urgent == "No"{
                                Text("No")
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(Theme.accentColor.opacity(0.2))
                                    .foregroundColor(Theme.primaryColor)
                                    .cornerRadius(30)
                            }
                            if annotation.urgent == "Yes"{
                                Text("Yes")
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(Theme.accentColor.opacity(0.2))
                                    .foregroundColor(Theme.primaryColor)
                                    .cornerRadius(30)
                            }
                            Spacer()
                        }
                        HStack() {
                            Text("Price: ")
                            Text("\(annotation.price ?? "No price available.")")
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(Theme.accentColor.opacity(0.2))
                                .foregroundColor(Theme.primaryColor)
                                .cornerRadius(30)
                            
                            if annotation.negotiable == "Yes"{
                                Text("Negotiable")
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(Theme.accentColor.opacity(0.2))
                                    .foregroundColor(Theme.primaryColor)
                                    .cornerRadius(30)
                            }
                            Spacer()
                        }
                        
                        // Description Text Field
                        TextField("How much are you charging for this work?", text: .constant(""))
                            .padding()
                            .background(Theme.accentColor.opacity(0.2))
                            .foregroundColor(Theme.primaryColor)
                            .cornerRadius(30)
                        
                        // Send Request Button
                        Button(action: {
                            selectedAnnotation = nil
                        }) {
                            Text("Notify the client")
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
                    .shadow(radius: 10)
                    .padding(.horizontal, 20)
                    Spacer(minLength: 5) // Control vertical spacing
                }
                .zIndex(1) // Ensure popup is above the background overlay
            }
        }
    }
}

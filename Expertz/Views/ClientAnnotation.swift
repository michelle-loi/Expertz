//
//  ClientAnnotation.swift
//  Expertz
//
//  Created by Alan Huynh on 2024-11-29.
//

import SwiftUI

struct ClientAnnotation: View {
    let annotation: MapBubble
    @Binding var selectedAnnotation: MapBubble?

    var body: some View {
        VStack {
            Spacer()
            VStack(spacing: 10) {
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
                Text("\(annotation.description ?? "No description available.")")
                    .font(.body)
                    .foregroundColor(Theme.primaryColor)
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
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
                TextField("How much are you charging for this work?", text: .constant(""))
                    .padding()
                    .background(Theme.accentColor.opacity(0.2))
                    .foregroundColor(Theme.primaryColor)
                    .cornerRadius(30)
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
            Spacer(minLength: 5)
        }
    }
}

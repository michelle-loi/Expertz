//
//  SearchBar.swift
//  Expertz
//
//  Created by Alan Huynh on 2024-11-29.
//
//  - Nested View Component for Homepage View
//  - Search Bar View Component, currently hardcoded
//

import SwiftUI

struct SearchBarView: View {
    @Binding var selectedPickerOption: String
    @State private var showPopup = false // State variable to control popup visibility

    var body: some View {
        ZStack {
            

            VStack(spacing: 15) {
                HStack {
                    TextField("Search for an expert...", text: .constant(""))
                        .customFormInputField()
                    
                }
                .padding(.horizontal)
                Button(action: {
                    showPopup = true // Show popup when button is clicked
                }) {
                    Image(systemName: "slider.horizontal.3")
                        .foregroundColor(.white)
                        .padding()
                        .background(Theme.accentColor)
                }
                Picker("", selection: $selectedPickerOption) {
                    Text("Client").tag("Client")
                    Text("Expert").tag("Expert")
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal)
            }
        }
        .padding(.top, 10)
        if showPopup {
            ZStack {
                Rectangle()
                    .fill(Color.black.opacity(0.1))
                    .ignoresSafeArea()
                    .onTapGesture {
                        showPopup = false // Close popup
                    }
                    .zIndex(0)
                VStack{
                    HStack {
                        Text("Price Range: ")
                        Text("Min")
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(Theme.accentColor.opacity(0.2))
                            .foregroundColor(Theme.primaryColor)
                            .cornerRadius(30)
                        Text("Max")
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(Theme.accentColor.opacity(0.2))
                            .foregroundColor(Theme.primaryColor)
                            .cornerRadius(30)
                        Spacer()
                    }
                    .padding()
                    HStack {
                        Text("Gender: ")
                        Text("Male")
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(Theme.accentColor.opacity(0.2))
                            .foregroundColor(Theme.primaryColor)
                            .cornerRadius(30)
                        Text("Female")
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(Theme.accentColor.opacity(0.2))
                            .foregroundColor(Theme.primaryColor)
                            .cornerRadius(30)
                        Text("Others")
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(Theme.accentColor.opacity(0.2))
                            .foregroundColor(Theme.primaryColor)
                            .cornerRadius(30)
                        Spacer()
                    }
                    .padding()
                    HStack {
                        Text("Ratings: ")
                        HStack(spacing: 5) {
                            Text("3.0")
                                .font(.headline)
                                .foregroundColor(.black)
                            Circle()
                                .fill(Color.yellow)
                                .frame(width: 20, height: 20) // Star icon placeholder
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Theme.accentColor.opacity(0.2))
                        .foregroundColor(Theme.primaryColor)
                        .cornerRadius(30)
                        HStack(spacing: 5) {
                            Text("4.0")
                                .font(.headline)
                                .foregroundColor(.black)
                            Circle()
                                .fill(Color.yellow)
                                .frame(width: 20, height: 20) // Star icon placeholder
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Theme.accentColor.opacity(0.2))
                        .foregroundColor(Theme.primaryColor)
                        .cornerRadius(30)
                        HStack(spacing: 5) {
                            Text("5.0")
                                .font(.headline)
                                .foregroundColor(.black)
                            Circle()
                                .fill(Color.yellow)
                                .frame(width: 20, height: 20) // Star icon placeholder
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Theme.accentColor.opacity(0.2))
                        .foregroundColor(Theme.primaryColor)
                        .cornerRadius(30)

                        Spacer()
                    }.padding()}
                .frame(maxWidth: .infinity)
                .background(Color.white)
                .cornerRadius(20)
                .shadow(radius: 10)
            }
        }
    }
}
#Preview {
    Homepage()
}

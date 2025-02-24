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
    @State private var isSelected = true
    @State private var isSelected2 = false

    @State private var showPopup = false // State variable to control popup visibility

    var body: some View {
        ZStack {
            

            VStack(spacing: 15) {
                HStack{
                    TextField("Search for an expert...", text: .constant(""))
                        .padding()
                        .background(.ultraThinMaterial)
                        .cornerRadius(Theme.cornerRadius)
                        .font(Theme.inputFont)
                        .foregroundColor(Theme.primaryColor)
                        .shadow(radius: 5)
                        .overlay(
                            RoundedRectangle(cornerRadius: 100)
                                .stroke(Theme.primaryColor, lineWidth: 2)
                        )
                        Button(action: {
                        showPopup = true // Show popup when button is clicked
                    }) {
                        Image(systemName: "slider.horizontal.3")
                            .foregroundColor(Theme.primaryColor)
                            .padding()
                            .background(.ultraThinMaterial)
                            .cornerRadius(100)
                            .shadow(radius: 5)
                            .overlay(
                                RoundedRectangle(cornerRadius: 100)
                                    .stroke(Theme.primaryColor, lineWidth: 2)
                            )
                    }
                    
                }
                .padding(.horizontal, 10)
                HStack(alignment: .firstTextBaseline, spacing: 1){
                    Button(action: {
                        selectedPickerOption = "Client" // Show popup when button is clicked
                        isSelected.toggle()
                        isSelected2.toggle()
                    }) {
                        if isSelected {
                            Text("Clients")
                                .customCTADesignButton()
                        } else {
                            Text("Clients")
                            .customAlternativeDesignButton()
                        }
                    }
                    Button(action: {
                        selectedPickerOption = "Expert" // Show popup when button is clicked
                        isSelected2.toggle()
                        isSelected.toggle()
                    }) {
                        if isSelected2 {
                            Text("Experts")
                                .customCTADesignButton()
                        } else {
                            Text("Experts")
                            .customAlternativeDesignButton()
                        }
                    }
                }
                
            }
        
        }
        .padding(.top, 10)
        if showPopup {
            ZStack {
                Rectangle()
                    .fill(Color.black.opacity(0.01))
                    .ignoresSafeArea()
                    .onTapGesture {
                        showPopup = false // Close popup
                    }
                    .zIndex(0)
                VStack{
                    HStack {
                        Text("Price Range: ")
                            .foregroundColor(Theme.primaryColor)
                        Text("Min")
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(Theme.primaryColor)
                            .foregroundColor(Theme.secondaryColor)
                            .cornerRadius(Theme.cornerRadius)
                            .shadow(radius: 5)
                            .overlay(
                                RoundedRectangle(cornerRadius: 100)
                                    .stroke(Theme.primaryColor, lineWidth: 2)
                            )
                        Text("Max")
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(Theme.primaryColor)
                            .foregroundColor(Theme.secondaryColor)
                            .cornerRadius(Theme.cornerRadius)
                            .shadow(radius: 5)
                            .overlay(
                                RoundedRectangle(cornerRadius: 100)
                                    .stroke(Theme.primaryColor, lineWidth: 2)
                            )
                        Spacer()
                    }
                    .padding()
                    HStack {
                        Text("Gender: ")
                            .foregroundColor(Theme.primaryColor)
                        Text("Male")
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(Theme.primaryColor)
                            .foregroundColor(Theme.secondaryColor)
                            .cornerRadius(Theme.cornerRadius)
                            .shadow(radius: 5)
                            .overlay(
                                RoundedRectangle(cornerRadius: 100)
                                    .stroke(Theme.primaryColor, lineWidth: 2)
                            )
                        Text("Female")
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(Theme.primaryColor)
                            .foregroundColor(Theme.secondaryColor)
                            .cornerRadius(Theme.cornerRadius)
                            .shadow(radius: 5)
                            .overlay(
                                RoundedRectangle(cornerRadius: 100)
                                    .stroke(Theme.primaryColor, lineWidth: 2)
                            )
                        Text("Others")
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(Theme.primaryColor)
                            .foregroundColor(Theme.secondaryColor)
                            .cornerRadius(Theme.cornerRadius)
                            .shadow(radius: 5)
                            .overlay(
                                RoundedRectangle(cornerRadius: 100)
                                    .stroke(Theme.primaryColor, lineWidth: 2)
                            )
                        Spacer()
                    }
                    .padding()
                    HStack {
                        Text("Ratings: ")
                            .foregroundColor(Theme.primaryColor)
                        HStack(spacing: 5) {
                            Text("3.0")
                                .font(.headline)
                                .foregroundColor(.white)
                            Circle()
                                .fill(Color.yellow)
                                .frame(width: 20, height: 20) // Star icon placeholder
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Theme.primaryColor)
                        .foregroundColor(Theme.secondaryColor)
                        .cornerRadius(Theme.cornerRadius)
                        .shadow(radius: 5)
                        .overlay(
                            RoundedRectangle(cornerRadius: 100)
                                .stroke(Theme.primaryColor, lineWidth: 2)
                        )
                        HStack(spacing: 5) {
                            Text("4.0")
                                .font(.headline)
                                .foregroundColor(.white)
                            Circle()
                                .fill(Color.yellow)
                                .frame(width: 20, height: 20) // Star icon placeholder
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Theme.primaryColor)
                        .foregroundColor(Theme.secondaryColor)
                        .cornerRadius(Theme.cornerRadius)
                        .shadow(radius: 5)
                        .overlay(
                            RoundedRectangle(cornerRadius: 100)
                                .stroke(Theme.primaryColor, lineWidth: 2)
                        )
                        HStack(spacing: 5) {
                            Text("5.0")
                                .font(.headline)
                                .foregroundColor(.white)
                            Circle()
                                .fill(Color.yellow)
                                .frame(width: 20, height: 20) // Star icon placeholder
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Theme.primaryColor)
                        .foregroundColor(Theme.secondaryColor)
                        .cornerRadius(Theme.cornerRadius)
                        .shadow(radius: 5)
                        .overlay(
                            RoundedRectangle(cornerRadius: 100)
                                .stroke(Theme.primaryColor, lineWidth: 2)
                        )

                        Spacer()
                    }.padding()}
                .background(.ultraThinMaterial)
                .cornerRadius(20)
                .shadow(radius: 5)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Theme.primaryColor, lineWidth: 2)
                )
                .padding(10)
            }
        }
    }
}
#Preview {
    Homepage()
}

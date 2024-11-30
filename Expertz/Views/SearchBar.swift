//
//  SearchBar.swift
//  Expertz
//
//  Created by Alan Huynh on 2024-11-29.
//

import SwiftUI

struct SearchBarView: View {
    @Binding var selectedPickerOption: String

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(Theme.accentColor)
                .frame(height: 120)
                .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
                .padding(.horizontal, 10)

            VStack(spacing: 15) {
                HStack {
                    TextField("Search for an expert...", text: .constant(""))
                        .padding()
                        .background(Theme.secondaryColor)
                        .cornerRadius(15)
                        .shadow(radius: 3)

                    Button(action: {}) {
                        Image(systemName: "slider.horizontal.3")
                            .foregroundColor(.white)
                            .padding()
                            .background(Theme.accentColor)
                    }
                }
                .padding(.horizontal)
                Picker("", selection: $selectedPickerOption) {
                    Text("Client").tag("Client")
                    Text("Expert").tag("Expert")
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal)
            }
        }
        .padding(.top, 10)
        .padding(.bottom, 55)
    }
}

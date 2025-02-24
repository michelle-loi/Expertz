//
//  Settings.swift
//  Expertz
//
//  Created by Amir on 2024-11-24.
//
//  - Functionality: Hardcoded | Allow user to view and change settings
//  - Future implementation: Add functionality
//

import SwiftUI

struct Settings: View {
    @State private var isDarkMode = false
    @State private var navigateToProfile = false
    @State private var navigateToRequests = false
    
    var body: some View {
        ZStack(alignment: .top){
            Color.clear
                .background(.ultraThinMaterial)
                .overlay(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color(red: 0.00, green: 0.90, blue: 0.90),
                            Color(red: 0.00, green: 0.90, blue: 0.90)
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                    .opacity(0.3)
                )
                .ignoresSafeArea()
            VStack(spacing: 20) {
                
                Button(action: {}) {
                    Text("Security and Privacy")
                }
                .customAlternativeDesignButton()
                
                
                Button(action: {
                }) {
                    Text("Help")
                }
                .customAlternativeDesignButton()
                
                
                HStack {
                    Text("Dark Mode")
                        .font(.headline)
                        .foregroundColor(Theme.primaryColor)
                    Spacer()
                    Toggle("", isOn: $isDarkMode)
                        .toggleStyle(SwitchToggleStyle(tint: Theme.primaryColor))
                }
                .padding()
                .background(.ultraThinMaterial)
                .cornerRadius(30)
                .overlay(
                    RoundedRectangle(cornerRadius: 30)
                        .stroke(Theme.primaryColor, lineWidth: 2)
                )
                
                Spacer()
            }
            .padding()}
        .navigationTitle("Settings")

    }
}

#Preview {
    Settings()
}

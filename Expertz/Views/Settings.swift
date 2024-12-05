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
        VStack(spacing: 20) {
            
            Button(action: {}) {
                Text("Security and Privacy")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Theme.accentColor)
                    .foregroundColor(Theme.primaryColor)
                    .cornerRadius(30)
            }
            
            Button(action: {
            }) {
                Text("Help")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Theme.accentColor)
                    .foregroundColor(Theme.primaryColor)
                    .cornerRadius(30)
            }
            
            HStack {
                Text("Dark Mode")
                    .font(.headline)
                    .foregroundColor(Theme.primaryColor)
                Spacer()
                Toggle("", isOn: $isDarkMode)
                    .toggleStyle(SwitchToggleStyle(tint: Theme.primaryColor))
            }
            .padding()
            .background(Theme.accentColor.opacity(0.2))
            .cornerRadius(30)
            
            Spacer()
        }
        .padding()
        .navigationTitle("Settings")
        .background(Theme.accentColor.opacity(0.2))
//        .background(LinearGradient(
//            gradient: Gradient(colors: [.cyan.opacity(0.6), Theme.accentColor.opacity(0.6)]),
//            startPoint: .top,
//            endPoint: .bottom
//        ))
    }
}

#Preview {
    Settings()
}

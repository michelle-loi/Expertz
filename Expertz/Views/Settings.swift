//
//  Settings.swift
//  Expertz
//
//  Created by Mark on 2024-11-24.
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
                    .background(Theme.accentColor.opacity(0.8))
                    .foregroundColor(Theme.primaryColor)
                    .cornerRadius(30)
            }
            
            Button(action: {
            }) {
                Text("Help")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Theme.accentColor.opacity(0.8))
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
        .background(Color.white.ignoresSafeArea())
    }
}

#Preview {
    Settings()
}

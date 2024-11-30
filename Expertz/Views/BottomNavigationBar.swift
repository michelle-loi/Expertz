//
//  BottomNavBar.swift
//  Expertz
//
//  Created by Alan Huynh on 2024-11-29.
//

import SwiftUI

struct BottomNavigationBar: View {
    @Binding var navigateToMessages: Bool
    @Binding var navigateToSettings: Bool
    @Binding var navigateToProfile: Bool
    @Binding var navigateToRequests: Bool
    @Binding var showPostJobView: Bool

    var body: some View {
        HStack {
            Spacer()
            Button(action: { navigateToMessages = true }) {
                VStack {
                    Image(systemName: "bubble.left.and.bubble.right")
                        .foregroundColor(Theme.primaryColor)
                        .background(Theme.accentColor)
                    Text("Messages")
                        .foregroundStyle(Theme.primaryColor)
                }
            }
            Button(action: { navigateToRequests = true }) {
                VStack {
                    Image(systemName: "person.crop.circle.badge.exclamationmark")
                        .foregroundColor(Theme.primaryColor)
                        .background(Theme.accentColor)
                    Text("Requests")
                        .foregroundStyle(Theme.primaryColor)
                }
            }
            Button(action: { showPostJobView.toggle() }) {
                Circle()
                    .fill(Theme.primaryColor)
                    .frame(width: 45, height: 45)
                    .overlay(Image(systemName: "plus")
                        .font(.system(size: 24))
                        .foregroundColor(.white))
            }
            Button(action: { navigateToSettings = true }) {
                VStack {
                    Image(systemName: "gear")
                        .foregroundColor(Theme.primaryColor)
                        .background(Theme.accentColor)
                    Text("Settings")
                        .foregroundStyle(Theme.primaryColor)
                }
            }
            Button(action: { navigateToProfile = true }) {
                VStack {
                    Image(systemName: "person")
                        .foregroundColor(Theme.primaryColor)
                        .background(Theme.accentColor)
                    Text("Profile")
                        .foregroundStyle(Theme.primaryColor)
                }
            }
            Spacer()
        }
        .frame(height: 70)
        .background(Theme.accentColor)
        .cornerRadius(30)
        .padding(.horizontal, 20)
    }
}

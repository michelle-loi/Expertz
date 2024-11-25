//
//  ContentView.swift
//  Expertz
//
//  Created by Alan Huynh on 2024-10-12.
//

import SwiftUI
import FirebaseAuth

struct ContentView: View {
    @State var isLoggedIn: Bool = false

    var body: some View {
        NavigationStack {
            if isLoggedIn {
                Homepage() // Replace with your home page view
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            NavigationLink(destination: AccountPage()) {
                                Text("Account")
                            }
                        }
                    }
            } else {
                Introduction() // Replace with your introduction view
            }
        }
        .onAppear {
            checkLoginStatus()
        }
    }

    private func checkLoginStatus() {
        if Auth.auth().currentUser != nil {
            isLoggedIn = true
        } else {
            isLoggedIn = false
        }
    }
}

#Preview {
    ContentView()
}

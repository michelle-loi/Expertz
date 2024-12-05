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
        
        // Nav Stack to direct user
        NavigationStack {
            if isLoggedIn { // If user is logged in, direct to Homepage
                Homepage()
            } else {
                Introduction() // If user is not logged in, direct to Intro page
            }
        }
        
        // On appear to check User Status
        .onAppear {
            print("Content View - onAppear Called") // Debug Statement
            checkLoginStatus()
        }
    }

    // Function to check if a user is logged in
    private func checkLoginStatus() {
        print("check login status called")
        print("Auth.auth().currentUser: \(String(describing: Auth.auth().currentUser))")
        if Auth.auth().currentUser != nil {
            print("login true")
            isLoggedIn = true
        } else {
            print("login false")
            isLoggedIn = false
        }
    }
}

#Preview {
    ContentView()
}

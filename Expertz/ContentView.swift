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
//                    .toolbar {
//                        ToolbarItem(placement: .navigationBarTrailing) {
//                            NavigationLink(destination: AccountPage()) {
//                                Text("Account")
//                            }
//                        }
//                    }
            } else {
                Introduction() // Replace with your introduction view
            }
        }
        .onAppear {
            print("Content View - onAppear Called")
            checkLoginStatus()
        }
    }

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

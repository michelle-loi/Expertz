//
//  AccountPage.swift
//  Expertz
//
//  Created by Alan Huynh on 2024-11-25.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct AccountPage: View {
    @State private var userEmail: String = ""
    @State private var userFirstName: String = ""
    @State private var userLastName: String = ""
    @State private var userAddress: String = ""
    @State private var userCountry: String = ""
    @State private var userGender: String = ""
    @State private var showError: Bool = false
    @State private var errorMessage: String = ""
    @State private var isLoggedOut: Bool = false // Track logout state
    @Environment(\.dismiss) var dismiss // To dismiss the view after logout
    
    var body: some View {
        NavigationStack {
            if isLoggedOut {
                ContentView() // Navigate to ContentView after logout
            } else {
                VStack(spacing: 20) {
                    Text("Account Information")
                        .font(.largeTitle)
                        .bold()
                        .padding(.top, 50)

                    if !userEmail.isEmpty {
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Email: \(userEmail)").font(.title3)
                            Text("First Name: \(userFirstName)").font(.title3)
                            Text("Last Name: \(userLastName)").font(.title3)
                            Text("Address: \(userAddress)").font(.title3)
                            Text("Country: \(userCountry)").font(.title3)
                            Text("Gender: \(userGender)").font(.title3)
                        }
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(10)
                    } else {
                        Text("Unable to retrieve account details.")
                            .font(.title2)
                            .foregroundColor(.red)
                    }

                    Spacer()

                    // Logout Button
                    Button(action: logOut) {
                        Text("Sign Out")
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.red)
                            .cornerRadius(10)
                    }
                    .padding(.horizontal)

                    if showError {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .padding(.top, 10)
                    }

                    Spacer()
                }
                .padding()
                .onAppear {
                    fetchUserDetails()
                }
            }
        }
    }

    private func fetchUserDetails() {
        if let user = Auth.auth().currentUser {
            let db = Firestore.firestore()
            let userDocRef = db.collection("UserProfiles").document(user.uid)

            userDocRef.getDocument { document, error in
                if let document = document, document.exists {
                    let data = document.data()
                    self.userEmail = data?["email"] as? String ?? "No email available"
                    self.userFirstName = data?["firstName"] as? String ?? "N/A"
                    self.userLastName = data?["lastName"] as? String ?? "N/A"
                    self.userAddress = data?["physicalAddress"] as? String ?? "N/A"
                    self.userCountry = data?["country"] as? String ?? "N/A"
                    self.userGender = data?["gender"] as? String ?? "N/A"
                } else {
                    showError = true
                    errorMessage = "Failed to fetch user details: \(error?.localizedDescription ?? "Unknown error")"
                }
            }
        }
    }

    private func logOut() {
        do {
            try Auth.auth().signOut()
            isLoggedOut = true // Trigger navigation to ContentView
        } catch let error {
            showError = true
            errorMessage = "Failed to log out: \(error.localizedDescription)"
        }
    }
}

#Preview {
    AccountPage()
}

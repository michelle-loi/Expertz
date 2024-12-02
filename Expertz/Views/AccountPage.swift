//
//  AccountPage.swift
//  Expertz
//
//  Created by Alan Huynh on 2024-11-25.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore
import GoogleSignIn

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
    @State private var text: String = "Sample Text"
    @State private var isEditing: Bool = false
    var body: some View {
        NavigationStack {
            if isLoggedOut {
                ContentView() // Navigate to ContentView after logout
            } else {
                VStack(spacing: 20) {
                    Text("\(userFirstName) \(userLastName)")
                        .font(.largeTitle)
                        .bold()
                        .foregroundStyle(Theme.primaryColor)
                    Circle()
                        .fill(Color.gray)
                        .frame(width: 100, height: 100)
                    
                    if !userEmail.isEmpty {
                        VStack(alignment: .leading) {
                            if isEditing {
                                Text("Email")
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(Theme.accentColor.opacity(0.5))
                                    .foregroundColor(Theme.primaryColor)
                                    .cornerRadius(30)
                                TextField("No Email Available", text: $userEmail)
                                    .padding()
                                    .background(Theme.accentColor.opacity(0.5))
                                    .foregroundColor(Theme.primaryColor)
                                    .cornerRadius(30)
                                Text("Address")
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(Theme.accentColor.opacity(0.5))
                                    .foregroundColor(Theme.primaryColor)
                                    .cornerRadius(30)
                                TextField("No Address", text: $userAddress)
                                    .padding()
                                    .background(Theme.accentColor.opacity(0.5))
                                    .foregroundColor(Theme.primaryColor)
                                    .cornerRadius(30)
                                Text("Country")
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(Theme.accentColor.opacity(0.5))
                                    .foregroundColor(Theme.primaryColor)
                                    .cornerRadius(30)
                                TextField("No Country Selected", text: $userCountry)
                                    .padding()
                                    .background(Theme.accentColor.opacity(0.5))
                                    .foregroundColor(Theme.primaryColor)
                                    .cornerRadius(30)
                                Text("Gender")
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(Theme.accentColor.opacity(0.5))
                                    .foregroundColor(Theme.primaryColor)
                                    .cornerRadius(30)
                                TextField("No Gender Selected", text: $userGender)
                                    .padding()
                                    .background(Theme.accentColor.opacity(0.5))
                                    .foregroundColor(Theme.primaryColor)
                                    .cornerRadius(30)
                            } else {
                                // Display text
                                Text("Email")
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(Theme.accentColor.opacity(0.5))
                                    .foregroundColor(Theme.primaryColor)
                                    .cornerRadius(30)
                                Text("\(userEmail)")
                                    .frame(maxWidth: .infinity,  alignment: .topLeading)
                                    .padding()
                                    .background(Theme.accentColor)
                                    .foregroundColor(Theme.primaryColor)
                                    .cornerRadius(30)
                                
                                Text("Address")
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(Theme.accentColor.opacity(0.5))
                                    .foregroundColor(Theme.primaryColor)
                                    .cornerRadius(30)
                                Text("\(userAddress)")
                                    .frame(maxWidth: .infinity,  alignment: .topLeading)
                                    .padding()
                                    .background(Theme.accentColor)
                                    .foregroundColor(Theme.primaryColor)
                                    .cornerRadius(30)
                                Text("Country")
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(Theme.accentColor.opacity(0.5))
                                    .foregroundColor(Theme.primaryColor)
                                    .cornerRadius(30)
                                Text("\(userCountry)")
                                    .frame(maxWidth: .infinity,  alignment: .topLeading)
                                    .padding()
                                    .background(Theme.accentColor)
                                    .foregroundColor(Theme.primaryColor)
                                    .cornerRadius(30)
                                Text("Gender")
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(Theme.accentColor.opacity(0.5))
                                    .foregroundColor(Theme.primaryColor)
                                    .cornerRadius(30)
                                Text("\(userGender)")
                                    .frame(maxWidth: .infinity,  alignment: .topLeading)
                                    .padding()
                                    .background(Theme.accentColor)
                                    .foregroundColor(Theme.primaryColor)
                                    .cornerRadius(30)
                                
                            }
                            
                            
                        }
                        
                    } else {
                        Text("Unable to retrieve account details.")
                            .font(.title2)
                            .foregroundColor(.red)
                    }
                    
                    Spacer()
                    HStack(){
                        Button(action: {
                            isEditing.toggle()
                        }) {
                            Text(isEditing ? "Done" : "Edit")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Theme.accentColor)
                                .foregroundColor(Theme.primaryColor)
                                .cornerRadius(30)
                        }
                        // Logout Button
                        Button(action: logOut) {
                            Text("Sign Out")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Theme.accentColor)
                                .foregroundColor(Theme.primaryColor)
                                .cornerRadius(30)
                        }}
                    
                    if showError {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .padding(.top, 10)
                    }
                    
                    Spacer()
                }
                .padding()
                .background(LinearGradient(
                    gradient: Gradient(colors: [.cyan.opacity(0.6), Theme.accentColor.opacity(0.6)]),
                    startPoint: .top,
                    endPoint: .bottom
                ))
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
        Task {
            do {
                // Call the GoogleSignInLogic's logout method
                try await GoogleSignInLogic().logout()
                
                // Trigger the state change for logging out
                try Auth.auth().signOut()
                isLoggedOut = true // Navigate to ContentView after logout
            } catch let error {
                showError = true
                errorMessage = "Failed to log out: \(error.localizedDescription)"
            }
        }
    }
}
#Preview {
    AccountPage()
}

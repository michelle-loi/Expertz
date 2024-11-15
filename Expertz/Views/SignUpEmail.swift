//
//  SignUpEmail.swift
//  Expertz
//
//  Created by Alan Huynh on 2024-10-13.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct SignUpEmail: View {
    @State private var nextPage = false
    @State private var backPage = false
    @State private var emailAddress: String = ""
    @State private var address: String = ""
    @State private var password: String = ""
    @State private var rePassword: String = ""
    @State private var errorMessage: String?
    
    var body: some View {
        VStack{
            Text("Lets get started!")
                .font(Theme.titleFont)
                .foregroundStyle(Theme.primaryColor)
                .padding(.top, 100)
            
            Text("Create an account")
                .font(Theme.inputFont)
                .foregroundStyle(Theme.primaryColor)
                .padding(.bottom, 100)
            
            TextField("Email Address", text: $emailAddress)
                .customFormInputField()
            
            TextField("Address", text: $address)
                .customFormInputField()
            
            SecureField("Password", text: $password)
                .customFormInputField()
            
            SecureField("Re Enter Password", text: $rePassword)
                .customFormInputField()
            
            if let errorMessage = errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding(.bottom, 10)
            }
            
            Spacer()
            
            Button(action: {
                signUpUser()
            }) {
                Text("Next")
            }
            .customCTADesignButton()

            Button(action: {
                backPage = true
            }) {
                Text("Back")
            }
            .customAlternativeDesignButton()
        }
        .navigationDestination(isPresented: $nextPage) {
            SignIn()
        }
        .navigationDestination(isPresented: $backPage) {
            Introduction()
        }
    }
    
    private func signUpUser() {
        guard password == rePassword else {
            errorMessage = "Passwords do not match"
            return
        }
        
        Auth.auth().createUser(withEmail: emailAddress, password: password) { authResult, error in
            if let error = error {
                print("Error details:", error)
                errorMessage = "Error: \(error.localizedDescription)"
            } else if let user = authResult?.user {
                // Proceed to create a Firestore document for the user
                createFirestoreProfile(for: user.uid)
            }
        }
    }
    
    private func createFirestoreProfile(for uid: String) {
        let db = Firestore.firestore()
        db.collection("UserProfiles").document(uid).setData([
            "username": emailAddress,
            "email": emailAddress,
            "physicalAddress": address
        ]) { error in
            if let error = error {
                errorMessage = "Firestore error: \(error.localizedDescription)"
            } else {
                // Successfully created user profile, navigate to the next page
                nextPage = true
            }
        }
    }
}

#Preview {
    SignUpEmail()
}

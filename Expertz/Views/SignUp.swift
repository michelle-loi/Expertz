//
//  SignUp.swift
//  Expertz
//
//  Created by Alan Huynh on 2024-10-13.
//

import SwiftUI
import Firebase
import FirebaseAuth
import GoogleSignIn
import GoogleSignInSwift

struct SignUp: View {
    @State private var navigateToSignUpEmailPage = false
    @State private var navigateToExistingAccountPage = false
    @State private var navigateToSignUpGooglePage = false
    @State private var GSIL = GoogleSignInLogic()
    
    // Store the sign-in data when using Google for sign-up
    @State private var userID = ""
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var email = ""

    var body: some View {
        NavigationStack {
            VStack {
                Text("Let's get started!")
                    .font(Theme.titleFont)
                    .foregroundStyle(Theme.primaryColor)
                    .padding(.top, 100)
                
                Text("Create an account")
                    .font(Theme.inputFont)
                    .foregroundStyle(Theme.primaryColor)
                    .padding(.bottom, 150)

                Button(action: {
                    navigateToSignUpEmailPage = true
                }) {
                    Text("Sign Up Using Email")
                }
                .customCTADesignButton()
                
                Button(action: {
                    GSIL.signInWithGoogle { success in
                        if success, let currentUser = Auth.auth().currentUser {
                            let userID = currentUser.uid
                            let firstName = currentUser.displayName?.components(separatedBy: " ").first ?? "First Name"
                            let lastName = currentUser.displayName?.components(separatedBy: " ").last ?? "Last Name"
                            let email = currentUser.email ?? "Email not available"
                            
                            // Save data for navigation
                            self.userID = userID
                            self.firstName = firstName
                            self.lastName = lastName
                            self.email = email
                            
                            // Check if the user already exists in Firestore
                            checkIfUserExists(userID: userID) { exists in
                                if exists {
                                    navigateToExistingAccountPage = true
                                } else {
                                    navigateToSignUpGooglePage = true
                                }
                            }
                        }
                    }
                }) {
                    Text("Sign Up With Google")
                }
                .customAlternativeDesignButton()

                HStack {
                    Text("Already have an account?")
                        .font(Theme.inputFont)
                        .foregroundStyle(Theme.primaryColor)
                    NavigationLink(destination: SignIn()) {
                        Text("Sign In")
                            .underline()
                            .foregroundStyle(Theme.primaryColor)
                    }
                }

                // Navigation destinations for each button
                .navigationDestination(isPresented: $navigateToSignUpEmailPage) {
                    SignUpEmail()
                }
                .navigationDestination(isPresented: $navigateToSignUpGooglePage) {
                    SignUpGoogle(userID: userID, firstName: firstName, lastName: lastName, email: email)
                }
                .navigationDestination(isPresented: $navigateToExistingAccountPage) {
                    Homepage() // Replace with your actual homepage view
                }
            }
            .padding()
            Spacer()
        }
    }
}

#Preview {
    SignUp()
}

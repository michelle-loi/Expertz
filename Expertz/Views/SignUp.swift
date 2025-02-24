//
//  SignUp.swift
//  Expertz
//
//  Created by Alan Huynh on 2024-10-13.
//
//  - Functionality: User Sign Up Page Navigation fork
//  - Allows users to sign up and create an account with either email or Google
//  - Future Implementation: allow creation of accounts by other methods
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
    @State private var GSIL = GoogleSignInLogic() // this utilizes the utility google sign in logic
    
    // Store the sign-in data when using Google for sign-up
    @State private var userID = ""
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var email = ""

    var body: some View {
        NavigationStack {
            ZStack(alignment: .top){
                
                Color.clear
                    .background(.ultraThinMaterial)
                    .overlay(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                Color(red: 0.00, green: 0.90, blue: 0.90),
                                Color(red: 0.00, green: 0.90, blue: 0.90)
                            ]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                        .opacity(0.3)
                    )
                    .ignoresSafeArea()
                VStack {
                    Text("Let's get started!")
                        .font(Theme.titleFont)
                        .fontWeight(.bold)
                        .foregroundStyle(Theme.primaryColor)
                        .padding(.top, 100)
                        
                    
                    Text("Create an account")
                        .font(Theme.inputFont)
                        .fontWeight(.bold)
                        .foregroundStyle(Theme.primaryColor)
                        .padding(.bottom, 150)
                    
                    
                    Button(action: {
                        navigateToSignUpEmailPage = true
                    }) {
                        Text("Sign Up Using Email")
                    }
                    .customCTADesignButton()
                    
                    Button(action: {
                        // uses the sign in with google function from GSIL that we imported above from the utilities
                        GSIL.signInWithGoogle { success in
                            if success, let currentUser = Auth.auth().currentUser {
                                // if successfully signed in we will assign user id, first name, last name and email address to variables that
                                // we will use later for user's account details.
                                let userID = currentUser.uid
                                let firstName = currentUser.displayName?.components(separatedBy: " ").first ?? "First Name"
                                let lastName = currentUser.displayName?.components(separatedBy: " ").last ?? "Last Name"
                                let email = currentUser.email ?? "Email not available"
                                
                                // Save data for navigation to google sign up page
                                self.userID = userID
                                self.firstName = firstName
                                self.lastName = lastName
                                self.email = email
                                
                                // Check if the user already exists in Firestore, if they don't exist then navigate to google sign up page
                                // if they do exist then just log in, no need to sign up.
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
                    // this navigates to the sign up with google page
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
}

#Preview {
    SignUp()
}

//
//  SignIn.swift
//  Expertz
//
//  Created by Alan Huynh on 2024-10-13.
//
//  - Functionality: User Sign in page
//  - Currently, users can sign in via email w/ firebase Auth
//  - and with Google Sign in
//  - Future Implementations: Allow alternative methods of signing in
//

import SwiftUI
import Firebase
import FirebaseAuth
import GoogleSignIn
import GoogleSignInSwift

struct SignIn: View {
    @State private var username_email: String = ""
    @State private var password: String = ""
    @State private var navigateToSignInPage = false
    @State private var navigateToSignUpGooglePage = false
    @State private var errorMessage: String?
    
    // For Google Sign-In, this calls the utility google sign in logic
    @State private var googleSignInLogic = GoogleSignInLogic()
    
    // Store the sign-in data when using Google for sign-up
    @State private var userID = ""
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var email = ""
    
    var body: some View {
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
                Text("Welcome Back!")
                    .font(Theme.titleFont)
                    .fontWeight(.bold)
                    .foregroundStyle(Theme.primaryColor)
                    .padding(.top, 100)
                Text("Sign in to your account")
                    .font(Theme.inputFont)
                    .foregroundStyle(Theme.primaryColor)
                    .padding(.bottom, 100)
                
                TextField("Username/Email", text: $username_email)
                    .customFormInputField()
                    .autocapitalization(.none)
                
                SecureField("Password", text: $password)
                    .customFormInputField()
                    .autocapitalization(.none)
                
                if let errorMessage = errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding(.bottom, 10)
                }
                
                Text("Forgot Password?")
                    .underline()
                    .foregroundStyle(Theme.primaryColor)
                    .padding(.bottom, 50)
                
                Button(action: {
                    authenticateUser()
                }) {
                    Text("Sign In")
                }
                .customCTADesignButton()
               
                
                Button(action: {
                    signInWithGoogle()
                }) {
                    Text("Sign in with Google")
                }
                .customAlternativeDesignButton()
                
                HStack{
                    Text("Don't have an account?")
                        .font(Theme.inputFont)
                        .foregroundStyle(Theme.primaryColor)
                    
                    NavigationLink(destination: SignUp()){
                        Text("Sign Up")
                            .underline()
                            .foregroundStyle(Theme.primaryColor)
                    }
                }
                
                Spacer()
                    .navigationDestination(isPresented: $navigateToSignInPage) {
                        Homepage()
                    }
                    .navigationDestination(isPresented: $navigateToSignUpGooglePage) {
                        SignUpGoogle(userID: userID, firstName: firstName, lastName: lastName, email: email)
                    }
            }}
    }
    
    // Google Sign-In Method
    private func signInWithGoogle() {
        // use google sign in logic to sign in with google
        googleSignInLogic.signInWithGoogle { success in
            // if successfully signed in get the current user from firebase
            if success, let currentUser = Auth.auth().currentUser {
                // After signing in with Google, retrieve user's details
                let userID = currentUser.uid
                let firstName = currentUser.displayName?.components(separatedBy: " ").first ?? "First Name"
                let lastName = currentUser.displayName?.components(separatedBy: " ").last ?? "Last Name"
                let email = currentUser.email ?? "Email not available"
                
                // Store the user data for navigation
                self.userID = userID
                self.firstName = firstName
                self.lastName = lastName
                self.email = email
                
                // Check if the user exists in the DB
                checkIfUserExists(userID: userID) { exists in
                    if exists {
                        // User exists, navigate to the homepage
                        navigateToSignInPage = true
                    } else {
                        // User does not exist, navigate to the Google sign-up page
                        navigateToSignUpGooglePage = true
                    }
                }
            }
        }
    }
    
    
    // Email/Password Authentication Method
    private func authenticateUser() {
        Auth.auth().signIn(withEmail: username_email, password: password) { authResult, error in
            if let error = error {
                errorMessage = "Error: \(error.localizedDescription)"
            } else {
                errorMessage = nil
                navigateToSignInPage = true
            }
        }
    }
}

#Preview {
    SignIn()
}

//
//  SignIn.swift
//  Expertz
//
//  Created by Alan Huynh on 2024-10-13.
//

import SwiftUI
import FirebaseAuth

struct SignIn: View {
    @State private var username_email: String = ""
    @State private var password: String = ""
    @State private var navigateToSignInPage = false
    @State private var navigateToSignInGoogle = false
    @State private var errorMessage: String?
    
    var body: some View {
        VStack {
            Text("Welcome Back!")
                .font(Theme.titleFont)
                .foregroundStyle(Theme.primaryColor)
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
            
            Text("Or")
                .padding(10)
            
            Button(action: {
                navigateToSignInGoogle = true
            }) {
                Text("Sign in with Google")
            }
            .customAlternativeDesignButton()
            
            HStack{
                Text("Don't have an account?")
                    .font(Theme.inputFont)
                    .foregroundStyle(Theme.primaryColor)
                
                NavigationLink(destination: AccType()){
                    Text("Sign Up")
                        .underline()
                        .foregroundStyle(Theme.primaryColor)
                }
            }
            
            Spacer()
            .navigationDestination(isPresented: $navigateToSignInPage) {
                Homepage()
            }
        }
    }
    
    private func authenticateUser() {
        Auth.auth().signIn(withEmail: username_email, password: password) { authResult, error in
            if let error = error {
                errorMessage = "Error: \(error.localizedDescription)"
            } else {
                // Clear error message if login is successful
                errorMessage = nil
                navigateToSignInPage = true
            }
        }
    }
}

#Preview {
    SignIn()
}

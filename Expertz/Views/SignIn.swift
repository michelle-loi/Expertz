//
//  SignIn.swift
//  Expertz
//
//  Created by Alan Huynh on 2024-10-13.
//

import SwiftUI


struct SignIn: View {
    @State private var username_email: String = ""
    @State private var password: String = ""
    @State private var navigateToSignInPage = false
    @State private var navigateToSignInGoogle = false
    
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
            TextField("Password", text: $password)
                .customFormInputField()
            Text("Forgot Password?")
                .underline()
                .foregroundStyle(Theme.primaryColor)
                .padding(.bottom, 50)
            
            Button(action: {
                navigateToSignInPage = true
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
                NavigationLink(destination: SignUp()){
                    Text("Sign Up")
                        .underline()
                        .foregroundStyle(Theme.primaryColor)
                }
            }
            
            Spacer()
        }
    }
}

#Preview {
    SignIn()
}

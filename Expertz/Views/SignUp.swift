//
//  SignUp.swift
//  Expertz
//
//  Created by Alan Huynh on 2024-10-13.
//

import SwiftUI

struct SignUp: View {
    @State private var navigateToSignUpEmailPage = false
    @State private var navigateToSignUpGooglePage = false
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("Lets get started!")
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
                    navigateToSignUpGooglePage = true
                }) {
                    Text("Sign Up With Google")
                }
                .customAlternativeDesignButton()

                HStack{
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
                    SignUpGoogle()
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


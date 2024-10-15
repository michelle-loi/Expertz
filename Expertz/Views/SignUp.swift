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
                Text("Sign Up Page:")
                    .font(.title)
                    .padding(.bottom, 20)

                Button(action: {
                    navigateToSignUpEmailPage = true
                }) {
                    Text("Sign Up Using Email")
                }
                .customCTADesignButton()
                .padding(.bottom, 10)

                Button(action: {
                    navigateToSignUpGooglePage = true
                }) {
                    Text("Sign Up With Google")
                }
                .customAlternativeDesignButton()

                // Navigation destinations for each button
                .navigationDestination(isPresented: $navigateToSignUpEmailPage) {
                    SignUpEmail()
                }
                .navigationDestination(isPresented: $navigateToSignUpGooglePage) {
                    SignUpGoogle()
                }
            }
            .padding()
        }
    }
}

#Preview {
    SignUp()
}


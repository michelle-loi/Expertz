//
//  AccType.swift
//  Expertz
//
//  Created by Alan Huynh on 2024-10-13.
//

import SwiftUI

struct AccType: View {
    @State private var navigateToSignUpEmailPage = false
    @State private var navigateToSignUpGooglePage = false
    @State private var clientAccType = false
    @State private var expertzAccType = false
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("Lets get started!")
                    .font(Theme.titleFont)
                    .foregroundStyle(Theme.titleFontColour)
                
                Text("Create an account")
                    .font(Theme.inputFont)
                    .foregroundStyle(Theme.primaryColor)
                    .padding(.bottom, 200)
                
                Button(action: {
                    clientAccType = true
                }) {
                    Text("Client")
                }
                .customAlternativeDesignButton()
                Button(action: {
                    clientAccType = true
                }) {
                    Text("Expert")
                }
                .customAlternativeDesignButton()
                Button(action: {
                    clientAccType = true
                }) {
                    Text("Both")
                }
                .customAlternativeDesignButton()
                
                Spacer()
                
                Button(action: {
                    navigateToSignUpEmailPage = true
                }) {
                    Text("Next")
                }
                .customCTADesignButton()

                Button(action: {
                    navigateToSignUpGooglePage = true
                }) {
                    Text("Back")
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
    AccType()
}

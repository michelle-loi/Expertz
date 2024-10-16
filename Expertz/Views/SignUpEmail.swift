//
//  SignUpEmail.swift
//  Expertz
//
//  Created by Alan Huynh on 2024-10-13.
//

import SwiftUI

struct SignUpEmail: View {
    @State private var nextPage = false
    @State private var backPage = false
    @State private var emailAddress: String = ""
    @State private var address: String = ""
    @State private var password: String = ""
    @State private var rePassword: String = ""
    
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
            
            TextField("Password", text: $password)
                .customFormInputField()
            
            TextField("Re Enter Password", text: $rePassword)
                .customFormInputField()
            
            Spacer()
            
            Button(action: {
                nextPage = true
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
            SignUpEmail()
        }
        .navigationDestination(isPresented: $backPage) {
            Introduction()
        }
    }
}

#Preview {
    SignUpEmail()
}

//
//  SignUpName.swift
//  Expertz
//
//  Created by Alan Huynh on 2024-10-13.
//

import SwiftUI

struct SignUpName: View {
    @State private var nextPage = false
    @State private var backPage = false
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    
    var body: some View {
        VStack{
            Text("Lets get started!")
                .font(Theme.titleFont)
                .foregroundStyle(Theme.primaryColor)
                .padding(.top, 100)
            Text("Create an account")
                .font(Theme.inputFont)
                .foregroundStyle(Theme.primaryColor)
                .padding(.bottom, 150)
            
            TextField("First Name", text: $firstName)
                .customFormInputField()
            
            TextField("Last Name", text: $lastName)
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
    SignUpName()
}

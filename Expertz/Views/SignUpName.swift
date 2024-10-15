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
    
    var body: some View {
        VStack{
            Text("SignUp Name")
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

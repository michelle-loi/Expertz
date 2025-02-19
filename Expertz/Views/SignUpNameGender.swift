//
//  SignUpNameGender.swift
//  Expertz
//
//  Created by Mark on 2025-02-18.
//
import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct SignUpNameGender: View {
    @ObservedObject var signUpData: SignUpData
    
    @State private var goToNextPage = false
    @Environment(\.dismiss) private var dismiss
    
    let genders = ["Male", "Female", "Other"]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            TextField("First Name", text: $signUpData.firstName)
                .customFormInputField()
            
            TextField("Last Name", text: $signUpData.lastName)
                .customFormInputField()
            
            // Gender Dropdown
            HStack {
                Text("Gender")
                    .font(.headline)
                Picker("Select Gender", selection: $signUpData.selectedGender) {
                    ForEach(genders, id: \.self) { gender in
                        Text(gender).tag(gender)
                    }
                }
                .pickerStyle(MenuPickerStyle())
            }
            
            Spacer()
            
            // Next & Back
            HStack {
                Button(action: {
                    dismiss()
                }) {
                    Text("Back")
                }
                .customAlternativeDesignButton()
                
                Button(action: {
                    goToNextPage = true
                }) {
                    Text("Next")
                }
                .customCTADesignButton()
            }
        }
        .padding()
        .navigationDestination(isPresented: $goToNextPage) {
            SignUpCountryAddress(signUpData: signUpData)
        }
        .navigationBarBackButtonHidden(true)
    }
}

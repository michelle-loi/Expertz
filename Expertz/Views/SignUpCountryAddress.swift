//
//  SignUpCountryAddress.swift
//  Expertz
//
//  Created by Mark on 2025-02-18.
//
import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct SignUpCountryAddress: View {
    @ObservedObject var signUpData: SignUpData
    
    @State private var goToNextPage = false
    @Environment(\.dismiss) private var dismiss
    
    let countries = ["United States", "Canada", "United Kingdom", "Australia", "Japan"]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Country Dropdown
            HStack {
                Text("Country")
                    .font(.headline)
                Picker("Select a Country", selection: $signUpData.selectedCountry) {
                    ForEach(countries, id: \.self) { country in
                        Text(country).tag(country)
                    }
                }
                .pickerStyle(MenuPickerStyle())
            }
            
            TextField("Address", text: $signUpData.address)
                .customFormInputField()
            
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
            SignUpExpertise(signUpData: signUpData)
        }
        .navigationBarBackButtonHidden(true)
    }
}

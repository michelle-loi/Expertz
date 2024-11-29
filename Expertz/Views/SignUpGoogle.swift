//
//  SignUpGoogle.swift
//  Expertz
//
//  Created by Ryan Loi on 2024-11-28
//  Credit : https://www.youtube.com/watch?v=vZEUAIHrsg8&t=482s
//

import SwiftUI
import Firebase
import GoogleSignIn
import GoogleSignInSwift

struct SignUpGoogle: View {
    var userID: String
    var firstName: String
    var lastName: String
    var email: String

    @State private var nextPage = false
    @State private var backPage = false
    @State private var address: String = ""
    @State private var selectedCountry: String = "United States" // Set a default valid country
    @State private var selectedGender: String = "Male" // Set a default gender
    @State private var isClient: Bool = true // Always true
    @State private var isExpert: Bool = false // Defaults to false
    @State private var selectedExpertCategories: [String] = [] // To store chosen categories
    @State private var errorMessage: String?
    
    let countries = ["United States", "Canada", "United Kingdom", "Australia", "Japan"]
    let genders = ["Male", "Female", "Other"]
    let expertCategories = ["Tutor", "Carpenter", "Electrician", "Plumber", "Mechanic"]
    
    var body: some View {
        ScrollView {
            VStack {
                Text("Let's get started!")
                    .font(Theme.titleFont)
                    .foregroundStyle(Theme.primaryColor)
                    .padding(.top, 10)
                
                Text("Complete your profile")
                    .font(Theme.inputFont)
                    .foregroundStyle(Theme.primaryColor)
                    .padding(.bottom, 10)
                
                // Display user details from Google Sign-In
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Text("First Name:")
                            .fontWeight(.semibold)
                        Spacer()
                        Text(firstName)
                            .foregroundColor(.gray)
                    }
                    
                    HStack {
                        Text("Last Name:")
                            .fontWeight(.semibold)
                        Spacer()
                        Text(lastName)
                            .foregroundColor(.gray)
                    }
                    
                    HStack {
                        Text("Email Address:")
                            .fontWeight(.semibold)
                        Spacer()
                        Text(email)
                            .foregroundColor(.gray)
                            .lineLimit(1)
                            .truncationMode(.middle)
                    }
                }
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(10)
                .padding(.horizontal)
                
                TextField("Address", text: $address)
                    .customFormInputField()
                
                // Gender Dropdown
                HStack {
                    Text("Gender")
                        .font(.headline)
                    Picker("Select Gender", selection: $selectedGender) {
                        ForEach(genders, id: \.self) { gender in
                            Text(gender).tag(gender)
                        }
                    }
                    .pickerStyle(MenuPickerStyle()) // Dropdown style
                }
                
                // Country Dropdown
                HStack {
                    Text("Country")
                        .font(.headline)
                    Picker("Select a Country", selection: $selectedCountry) {
                        ForEach(countries, id: \.self) { country in
                            Text(country).tag(country)
                        }
                    }
                    .pickerStyle(MenuPickerStyle()) // Dropdown style
                }
                
                Toggle("Register as an Expert", isOn: $isExpert)
                    .padding(10)
                    .toggleStyle(SwitchToggleStyle(tint: .blue))
                
                // Show expert categories if "Expert" is true
                if isExpert {
                    Text("Select Your Expertise")
                        .font(.headline)
                        .padding(.top, 10)
                    
                    // Custom checkboxes for categories
                    ForEach(expertCategories, id: \.self) { category in
                        Toggle(category, isOn: Binding(
                            get: { selectedExpertCategories.contains(category) },
                            set: { isSelected in
                                if isSelected {
                                    selectedExpertCategories.append(category)
                                } else {
                                    selectedExpertCategories.removeAll { $0 == category }
                                }
                            }
                        ))
                        .toggleStyle(CheckboxToggleStyle()) // Custom checkbox styling
                    }
                }
                
                Spacer()
                
                Button(action: {
                    saveUserProfile()
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
                SignIn()
            }
            .navigationDestination(isPresented: $backPage) {
                Introduction()
            }
            .navigationBarBackButtonHidden(true)
        }
    }
    
    private func saveUserProfile() {
        // Check for valid selections (not the default placeholder values)
        guard selectedGender != "Select Gender", selectedCountry != "Select a Country" else {
            errorMessage = "Please select valid values for gender and country."
            return
        }
        
        let db = Firestore.firestore()
        db.collection("UserProfiles").document(userID).setData([
            "userID": userID,
            "firstName": firstName,
            "lastName": lastName,
            "email": email,
            "physicalAddress": address,
            "country": selectedCountry,
            "gender": selectedGender,
            "isClient": isClient, // Always true
            "isExpert": isExpert,
            "expertCategories": isExpert ? selectedExpertCategories : [] // Only include categories if "Expert" is true
        ]) { error in
            if let error = error {
                errorMessage = "Firestore error: \(error.localizedDescription)"
            } else {
                nextPage = true // Navigate to the next screen
            }
        }
    }
}

#Preview {
    SignUpGoogle(userID: "12345ABC", firstName: "Test", lastName: "Test", email: "Test@example.com")
}

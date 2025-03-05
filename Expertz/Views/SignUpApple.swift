// SignUpApple.swift
// Expertz
//
// Created by Ryan Loi on 2024-03-03.

import SwiftUI
import Firebase

struct SignUpApple: View {
    var userID: String
    var firstName: String
    var lastName: String
    var email: String
    
    @State private var address: String = ""
    @State private var selectedCountry: String = "United States"
    @State private var selectedGender: String = "Male"
    @State private var isClient: Bool = true
    @State private var isExpert: Bool = false
    @State private var selectedExpertCategories: [String] = []
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
                
                HStack {
                    Text("Gender")
                        .font(.headline)
                    Picker("Select Gender", selection: $selectedGender) {
                        ForEach(genders, id: \.self) { gender in
                            Text(gender).tag(gender)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                }
                
                HStack {
                    Text("Country")
                        .font(.headline)
                    Picker("Select a Country", selection: $selectedCountry) {
                        ForEach(countries, id: \.self) { country in
                            Text(country).tag(country)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                }
                
                Toggle("Register as an Expert", isOn: $isExpert)
                    .padding(10)
                    .toggleStyle(SwitchToggleStyle(tint: .blue))
                
                if isExpert {
                    Text("Select Your Expertise")
                        .font(.headline)
                        .padding(.top, 10)
                    
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
                        .toggleStyle(CheckboxToggleStyle())
                    }
                }
                
                Spacer()
                
                Button(action: {
                    // Save user data to Firebase
                    saveUserData()
                }) {
                    Text("Finish Setup")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Theme.primaryColor)
                        .cornerRadius(10)
                }
                .padding(.horizontal)
                .padding(.bottom, 50)
            }
            .padding(.top)
        }
    }
    
    func saveUserData() {
        // Save the user data to Firestore
        let db = Firestore.firestore()
        let userRef = db.collection("users").document(userID)
        
        userRef.setData([
            "userID": userID,
            "firstName": firstName,
            "lastName": lastName,
            "email": email,
            "address": address,
            "country": selectedCountry,
            "gender": selectedGender,
            "isExpert": isExpert,
            "expertCategories": selectedExpertCategories
        ]) { error in
            if let error = error {
                self.errorMessage = "Failed to save data: \(error.localizedDescription)"
            } else {
                print("User data saved successfully!")
                // Navigate to the main page after successful sign-up
            }
        }
    }
}

#Preview {
    SignUpApple(userID: "userID", firstName: "John", lastName: "Doe", email: "johndoe@example.com")
}

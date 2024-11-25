//
//  SignUpEmail.swift
//  Expertz
//
//  Created by Alan Huynh on 2024-10-13.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct CheckboxToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        Button(action: { configuration.isOn.toggle() }) {
            HStack {
                Image(systemName: configuration.isOn ? "checkmark.square" : "square")
                    .foregroundColor(configuration.isOn ? .blue : .gray)
                configuration.label
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct SignUpEmail: View {
    @State private var nextPage = false
    @State private var backPage = false
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var emailAddress: String = ""
    @State private var address: String = ""
    @State private var selectedCountry: String = "Select a Country"
    @State private var selectedGender: String = "Select Gender"
    @State private var isClient: Bool = true // Always true
    @State private var isExpert: Bool = false // Defaults to false
    @State private var selectedExpertCategories: [String] = [] // To store chosen categories
    @State private var password: String = ""
    @State private var rePassword: String = ""
    @State private var errorMessage: String?

    let countries = ["United States", "Canada", "United Kingdom", "Australia", "Japan"]
    let genders = ["Male", "Female", "Other"]
    let expertCategories = ["Tutor", "Carpenter", "Electrician", "Plumber", "Mechanic"]
    
    var body: some View {
        ScrollView{
            VStack{
                Text("Lets get started!")
                    .font(Theme.titleFont)
                    .foregroundStyle(Theme.primaryColor)
                    .padding(.top, 10)
                
                Text("Create an account")
                    .font(Theme.inputFont)
                    .foregroundStyle(Theme.primaryColor)
                    .padding(.bottom, 10)
                
                TextField("Email Address", text: $emailAddress)
                    .customFormInputField()
                
                SecureField("Password", text: $password)
                    .customFormInputField()
                
                SecureField("Re Enter Password", text: $rePassword)
                    .customFormInputField()
                
                if let errorMessage = errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding(.bottom, 10)
                }
                
                TextField("First Name", text: $firstName)
                    .customFormInputField()
                
                TextField("Last Name", text: $lastName)
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
                //.padding(.vertical, 10)
                
                TextField("Address", text: $address)
                    .customFormInputField()
                
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
                //.padding(.vertical, 10)
                
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
                    signUpUser()
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
    
    private func signUpUser() {
        guard password == rePassword else {
            errorMessage = "Passwords do not match"
            return
        }
        
        Auth.auth().createUser(withEmail: emailAddress, password: password) { authResult, error in
            if let error = error {
                print("Error details:", error)
                errorMessage = "Error: \(error.localizedDescription)"
            } else if let user = authResult?.user {
                // Proceed to create a Firestore document for the user
                createFirestoreProfile(for: user.uid)
            }
        }
    }
    
    private func createFirestoreProfile(for uid: String) {
        let db = Firestore.firestore()
        db.collection("UserProfiles").document(uid).setData([
            "username": emailAddress,
            "firstName": firstName,
            "lastName": lastName,
            "email": emailAddress,
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
    SignUpEmail()
}

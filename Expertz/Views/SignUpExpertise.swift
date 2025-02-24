//
//  SignUpExpertise.swift
//  Expertz
//
//  Created by Mark on 2025-02-18.
//
import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct SignUpExpertise: View {
    @ObservedObject var signUpData: SignUpData
    
    @State private var nextPage = false
    @Environment(\.dismiss) private var dismiss
    
    // For demonstration, reusing the “bubbles” approach:
    @State private var searchExpertise: String = ""
    
    var body: some View {
        ZStack(alignment: .top){
            Color.clear
                .background(.ultraThinMaterial)
                .overlay(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color(red: 0.00, green: 0.90, blue: 0.90),
                            Color(red: 0.00, green: 0.90, blue: 0.90)
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                    .opacity(0.3)
                )
                .ignoresSafeArea()
                VStack(spacing: 16) {
                    Text("Create an account")
                        .font(Theme.titleFont)
                        .fontWeight(.bold)
                        .foregroundStyle(Theme.primaryColor)
                        .padding(.bottom, 100)
                        .padding(.top, 100)
                    Toggle("Register as an Expert", isOn: $signUpData.isExpert)
                        .padding()
                        .toggleStyle(SwitchToggleStyle(tint: .blue))
                    
                    if signUpData.isExpert {
                        Text("Enter Your Expertise")
                            .font(.headline)
                            .padding(.top, 10)
                        
                        TextField("Type expertise and hit enter", text: $searchExpertise)
                            .customFormInputField()
                            .onSubmit {
                                addCustomExpertise()
                            }
                        
                        // Render selected expertise as bubbles below the text field.
                        if !signUpData.selectedExpertCategories.isEmpty {
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 8) {
                                    ForEach(signUpData.selectedExpertCategories, id: \.self) { expertise in
                                        HStack {
                                            Text(expertise)
                                                .foregroundColor(.primary)
                                            Button(action: {
                                                if let index = signUpData.selectedExpertCategories.firstIndex(of: expertise) {
                                                    signUpData.selectedExpertCategories.remove(at: index)
                                                }
                                            }) {
                                                Image(systemName: "xmark.circle.fill")
                                                    .foregroundColor(.primary)
                                            }
                                        }
                                        .padding(.horizontal, 10)
                                        .padding(.vertical, 5)
                                        .background(
                                            RoundedRectangle(cornerRadius: 8)
                                                .fill(Color(UIColor.systemGray6))
                                        )
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 8)
                                                .stroke(Color.gray, lineWidth: 1)
                                        )
                                    }
                                }
                                .padding(.top, 5)
                            }
                        }
                    }
                    
                    // Show error message if any
                    if let error = signUpData.errorMessage {
                        Text(error)
                            .foregroundColor(.red)
                    }
                    
                    Spacer()
                    
                    // Next & Back
                    VStack {
                        Button(action: {
                            dismiss()
                        }) {
                            Text("Back")
                        }
                        .customAlternativeDesignButton()
                        
                        Button(action: {
                            signUpUser()
                        }) {
                            Text("Next")
                        }
                        .customCTADesignButton()
                    }
                
                .padding()}
        }
        .navigationDestination(isPresented: $nextPage) {
            // For example, go to a SignIn screen or a Home screen after successful sign-up
            Homepage()
        }
        .navigationBarBackButtonHidden(true)
    }
    
    /// Adds custom expertise to the user’s list.
    private func addCustomExpertise() {
        let trimmed = searchExpertise.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        if !signUpData.selectedExpertCategories.contains(trimmed) {
            signUpData.selectedExpertCategories.append(trimmed)
        }
        searchExpertise = ""
    }
    
    /// Creates the user account and Firestore profile.
    private func signUpUser() {
        // Check that passwords match
        guard signUpData.password == signUpData.rePassword else {
            signUpData.errorMessage = "Passwords do not match."
            return
        }
        
        Auth.auth().createUser(withEmail: signUpData.emailAddress, password: signUpData.password) { authResult, error in
            if let error = error {
                print("Error details:", error)
                signUpData.errorMessage = "Error: \(error.localizedDescription)"
            } else if let user = authResult?.user {
                createFirestoreProfile(for: user.uid)
            }
        }
    }
    
    /// Stores additional user info in Firestore.
    private func createFirestoreProfile(for uid: String) {
        let db = Firestore.firestore()
        db.collection("UserProfiles").document(uid).setData([
            "username": signUpData.emailAddress,
            "firstName": signUpData.firstName,
            "lastName": signUpData.lastName,
            "email": signUpData.emailAddress,
            "physicalAddress": signUpData.address,
            "country": signUpData.selectedCountry,
            "gender": signUpData.selectedGender,
            "isClient": signUpData.isClient,
            "isExpert": signUpData.isExpert,
            "expertCategories": signUpData.isExpert ? signUpData.selectedExpertCategories : []
        ]) { error in
            if let error = error {
                signUpData.errorMessage = "Firestore error: \(error.localizedDescription)"
            } else {
                // If successful, navigate onward
                nextPage = true
            }
        }
    }
}

#Preview {
    SignUpExpertise(signUpData: SignUpData())
}

//
//  SignUpData.swift
//  Expertz
//
//  Created by Mark on 2025-02-18.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

/// An observable model that stores all sign-up data across multiple pages.
class SignUpData: ObservableObject {
    @Published var emailAddress: String = ""
    @Published var password: String = ""
    @Published var rePassword: String = ""
    
    @Published var firstName: String = ""
    @Published var lastName: String = ""
    @Published var selectedGender: String = "Select Gender"
    
    @Published var address: String = ""
    @Published var selectedCountry: String = "Select a Country"
    
    @Published var isClient: Bool = true
    @Published var isExpert: Bool = false
    @Published var selectedExpertCategories: [String] = []
    
    // Holds any error message if sign-up fails
    @Published var errorMessage: String?
}


import SwiftUI
import FirebaseAuth
import FirebaseFirestore

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
    
    @Published var errorMessage: String?
}


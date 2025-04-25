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

struct GoogleSignUp: View {
    @State private var nextPage = false
    @State private var backPage = false
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var emailAddress: String = ""
    @State private var address: String = ""
    @State private var selectedCountry: String = "Select a Country"
    @State private var selectedGender: String = "Select Gender"
    @State private var isClient: Bool = true
    @State private var isExpert: Bool = false
    @State private var selectedExpertCategories: [String] = []
    @State private var searchExpertise: String = ""
    @State private var password: String = ""
    @State private var rePassword: String = ""
    @State private var errorMessage: String?

    let countries = ["United States", "Canada", "United Kingdom", "Australia", "Japan"]
    let genders = ["Male", "Female", "Other"]
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
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
                    .pickerStyle(MenuPickerStyle())
                }
                
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
                    .pickerStyle(MenuPickerStyle())
                }
                
                Toggle("Register as an Expert", isOn: $isExpert)
                    .padding(10)
                    .toggleStyle(SwitchToggleStyle(tint: .blue))
                
                if isExpert {
                    Text("Enter Your Expertise")
                        .font(.headline)
                        .padding(.top, 10)
                    
                    // TextField for entering custom expertise.
                    // When the user hits enter, addCustomExpertise() is called.
                    TextField("Type expertise and hit enter", text: $searchExpertise)
                        .customFormInputField()
                        .onSubmit {
                            addCustomExpertise()
                        }
                    
                    // Render selected expertise as bubbles below the text field.
                    if !selectedExpertCategories.isEmpty {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 8) {
                                ForEach(selectedExpertCategories, id: \.self) { expertise in
                                    HStack {
                                        Text(expertise)
                                            .foregroundColor(.primary)
                                        Button(action: {
                                            if let index = selectedExpertCategories.firstIndex(of: expertise) {
                                                selectedExpertCategories.remove(at: index)
                                            }
                                        }) {
                                            Image(systemName: "xmark.circle.fill")
                                                .foregroundColor(.primary)
                                        }
                                    }
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 5)
                                    // Bubble background matches the text field's background.
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
            .padding()
            .navigationDestination(isPresented: $nextPage) {
                SignIn()
            }
            .navigationDestination(isPresented: $backPage) {
                Introduction()
            }
            .navigationBarBackButtonHidden(true)
        }
    }
    
    // Adds custom expertise when the user hits enter.
    private func addCustomExpertise() {
        let trimmed = searchExpertise.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        if !selectedExpertCategories.contains(trimmed) {
            selectedExpertCategories.append(trimmed)
        }
        searchExpertise = ""
    }
    
    // Function to create the user account.
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
                createFirestoreProfile(for: user.uid)
            }
        }
    }
    
    // Function to store additional user info in Firestore.
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
            "isClient": isClient,
            "isExpert": isExpert,
            "expertCategories": isExpert ? selectedExpertCategories : []
        ]) { error in
            if let error = error {
                errorMessage = "Firestore error: \(error.localizedDescription)"
            } else {
                nextPage = true
            }
        }
    }
}

#Preview {
    SignUpEmail()
}


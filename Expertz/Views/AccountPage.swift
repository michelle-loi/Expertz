//  - Functionality: Account page for user to view and edit
//      their account information.
//  - Currently, data is pulled but cannot be edited and updated to DB
//  - Future Implementation: Allow user to edit account information and
//      be able to add a user account image
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore
import GoogleSignIn

struct AccountPage: View {
    @State private var userEmail: String = ""
    @State private var userFirstName: String = ""
    @State private var userLastName: String = ""
    @State private var userAddress: String = ""
    @State private var userCountry: String = ""
    @State private var userGender: String = ""
    @State private var showError: Bool = false
    @State private var errorMessage: String = ""
    @State private var isLoggedOut: Bool = false        // Track logout state
    @Environment(\.dismiss) var dismiss                 // To dismiss the view after logout
    @State private var text: String = "Sample Text"
    @State private var isEditing: Bool = false
    var body: some View {
        NavigationStack {
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
            if isLoggedOut {
                ContentView() // Navigate to ContentView after logout
            } else {
                VStack(spacing: 20) {
                    NavigationLink("Go to Dashboard", destination: Dashboard())
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text("\(userFirstName) \(userLastName)")
                        .font(.largeTitle)
                        .bold()
                        .foregroundStyle(Theme.primaryColor)
                    Circle()
                        .fill(Color.gray)
                        .frame(width: 100, height: 100)
                    
                    if !userEmail.isEmpty {
                        VStack(alignment: .leading) {
                            if isEditing {
                                Text("Email")
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(Theme.accentColor.opacity(0.5))
                                    .foregroundColor(Theme.primaryColor)
                                    .cornerRadius(30)
                                
                                //  this prevents email editing as we will do it via firebase
                                Text("\(userEmail)")
                                    .frame(maxWidth: .infinity,  alignment: .topLeading)
                                    .padding()
                                    .background(.ultraThinMaterial)
                                    .foregroundColor(Theme.primaryColor)
                                    .cornerRadius(30)
                                Text("Address")
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(Theme.accentColor.opacity(0.5))
                                    .foregroundColor(Theme.primaryColor)
                                    .cornerRadius(30)
                                TextField("No Address", text: $userAddress)
                                    .customFormInputField()
                                
                                Text("Country")
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(Theme.accentColor.opacity(0.5))
                                    .foregroundColor(Theme.primaryColor)
                                    .cornerRadius(30)
                                
                                ZStack {
                                    Picker("Select a Country", selection: $userCountry) {
                                        ForEach(["United States", "Canada", "United Kingdom", "Australia", "Japan"], id: \.self) { country in
                                            Text(country).tag(country)
                                        }
                                    }
                                    .pickerStyle(MenuPickerStyle())
                                    .frame(maxWidth: .infinity, maxHeight: 21)
                                    .padding(.horizontal)
                                }
                                .customFormInputField()
                                .padding(.vertical, 0)
                                 

                                Text("Gender")
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(Theme.accentColor.opacity(0.5))
                                    .foregroundColor(Theme.primaryColor)
                                    .cornerRadius(30)
                                TextField("No Gender Selected", text: $userGender)
                                    .customFormInputField()

                            } else {
                                // Display text
                                Text("Email")
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(Theme.accentColor.opacity(0.5))
                                    .foregroundColor(Theme.primaryColor)
                                    .cornerRadius(30)
                                Text("\(userEmail)")
                                    .frame(maxWidth: .infinity,  alignment: .topLeading)
                                    .padding()
                                    .background(.ultraThinMaterial)
                                    .foregroundColor(Theme.primaryColor)
                                    .cornerRadius(30)
                                
                                Text("Address")
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(Theme.accentColor.opacity(0.5))
                                    .foregroundColor(Theme.primaryColor)
                                    .cornerRadius(30)
                                Text("\(userAddress)")
                                    .frame(maxWidth: .infinity,  alignment: .topLeading)
                                    .padding()
                                    .background(.ultraThinMaterial)
                                    .foregroundColor(Theme.primaryColor)
                                    .cornerRadius(30)
                                Text("Country")
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(Theme.accentColor.opacity(0.5))
                                    .foregroundColor(Theme.primaryColor)
                                    .cornerRadius(30)
                                Text("\(userCountry)")
                                    .frame(maxWidth: .infinity,  alignment: .topLeading)
                                    .padding()
                                    .background(.ultraThinMaterial)
                                    .foregroundColor(Theme.primaryColor)
                                    .cornerRadius(30)
                                Text("Gender")
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(Theme.accentColor.opacity(0.5))
                                    .foregroundColor(Theme.primaryColor)
                                    .cornerRadius(30)
                                Text("\(userGender)")
                                    .frame(maxWidth: .infinity,  alignment: .topLeading)
                                    .padding()
                                    .background(.ultraThinMaterial)
                                    .foregroundColor(Theme.primaryColor)
                                    .cornerRadius(30)
                                
                            }
                            
                            
                        }
                        
                    } else {
                        Text("Unable to retrieve account details.")
                            .font(.title2)
                            .foregroundColor(.red)
                    }
                    
                    Spacer()
                    HStack(){
                        Button(action: {
                            if isEditing {
                                    updateUserDetails()
                                }
                            isEditing.toggle()
                        }) {
                            Text(isEditing ? "Done" : "Edit")
                        }
                        .customAlternativeDesignButton()
                        // Logout Button
                        Button(action: logOut) {
                            Text("Sign Out")
                        }
                        .customAlternativeDesignButton()
                    }

                    
                    if showError {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .padding(.top, 10)
                    }
                    
                    Spacer()
                }
                .padding()
                .navigationTitle("Profile")
                .onAppear {
                    fetchUserDetails()
                }}
            }
        }
    }
    
    private func fetchUserDetails() {
        if let user = Auth.auth().currentUser {
            let db = Firestore.firestore()
            let userDocRef = db.collection("UserProfiles").document(user.uid)
            
            userDocRef.getDocument { document, error in
                if let document = document, document.exists {
                    let data = document.data()
                    self.userEmail = data?["email"] as? String ?? "No email available"
                    self.userFirstName = data?["firstName"] as? String ?? "N/A"
                    self.userLastName = data?["lastName"] as? String ?? "N/A"
                    self.userAddress = data?["physicalAddress"] as? String ?? "N/A"
                    self.userCountry = data?["country"] as? String ?? "N/A"
                    self.userGender = data?["gender"] as? String ?? "N/A"
                } else {
                    showError = true
                    errorMessage = "Failed to fetch user details: \(error?.localizedDescription ?? "Unknown error")"
                }
            }
        }
    }
    
    private func logOut() {
        Task {
            do {
                // Call the GoogleSignInLogic's logout method
                try await GoogleSignInLogic().logout()
                
                // Firebase User Logout
                try Auth.auth().signOut()
                isLoggedOut = true
            } catch let error {
                showError = true
                errorMessage = "Failed to log out: \(error.localizedDescription)"
            }
        }
    }
    
    
    // updates the user's info when they edit
    private func updateUserDetails() {
        guard let user = Auth.auth().currentUser else {
            showError = true
            errorMessage = "User not logged in."
            return
        }
        
        let db = Firestore.firestore()
        let userDocRef = db.collection("UserProfiles").document(user.uid)
        
        let updatedData: [String: Any] = [
            "email": userEmail,
            "physicalAddress": userAddress,
            "country": userCountry,
            "gender": userGender
        ]
        
        userDocRef.setData(updatedData, merge: true) { error in
            if let error = error {
                showError = true
                errorMessage = "Failed to update profile: \(error.localizedDescription)"
            } else {
                showError = false
            }
        }
    }

    
    
}
#Preview {
    AccountPage()
}

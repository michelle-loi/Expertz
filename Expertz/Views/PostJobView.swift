//
//  PostJobView.swift
//  Expertz
//
//  Created by Alan Huynh on 2024-11-27.
//
//  - Functionality: View page used to allow users to create Client or Expert Request
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct PostJobView: View {
    @State private var isExpert: Bool = false           // Determines if the user is an expert
    @State private var requestType: String = "Client"   // Default to Client Request
    @State private var title: String = ""               // Request Title
    @State private var description: String = ""         // Request Description
    @State private var address: String = ""             // Request Address
    @State private var inPerson: String = "Yes"         // Dropdown default
    @State private var online: String = "Yes"           // Dropdown default
    @State private var expertise: [String] = []         // Pulled from user profile
    @State private var price: String = ""               // Price
    @State private var isNegotiable: String = "Yes"     // Negotiable
    @State private var isUrgent: String = "No"          // Urgency
    @State private var showError: Bool = false          // Error Flag
    @State private var errorMessage: String = ""        // Error string
    @Environment(\.dismiss) var dismiss                 // To dismiss the view

    let dropdownOptions = ["Yes", "No", "Only"]         // List
    let dropdownUrgent = ["Yes", "No"]                  // List

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    Text("Request/Availability")
                        .font(.largeTitle)
                        .bold()
                        .foregroundStyle(Theme.primaryColor)

                    // Conditionally show the request type picker if the user is an expert
                    if isExpert {
                        Text("Request Type")
                            .padding(.horizontal, 40)
                            .padding(.vertical, 6)
                            .font(.headline)
                            
                            .foregroundColor(Theme.primaryColor)
                            .cornerRadius(30)
                        Picker("", selection: $requestType) {
                            Text("Client").tag("Client")
                            Text("Expert").tag("Expert")
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .padding(.horizontal)
                    }

                    // Title Field
                    Text("Title")
                        .padding(.horizontal, 40)
                        .padding(.vertical, 6)
                        .font(.headline)
                        .foregroundColor(Theme.primaryColor)
                        .cornerRadius(30)
                    TextField("Enter a title for your request", text: $title)
                        .padding()
                        .background(Theme.accentColor)
                        .cornerRadius(Theme.cornerRadius)
                        .font(Theme.inputFont)
                        .foregroundColor(.black)
                        .padding(.horizontal, Theme.buttonPadding)

                    // Address Field
                    if requestType == "Client" || isExpert {
                        Text("Address")
                            .padding(.horizontal, 40)
                            .padding(.vertical, 6)
                            .font(.headline)
                            .foregroundColor(Theme.primaryColor)
                            .cornerRadius(30)
                        TextField("Enter an address", text: $address)
                            .padding()
                            .background(Theme.accentColor)
                            .cornerRadius(Theme.cornerRadius)
                            .font(Theme.inputFont)
                            .foregroundColor(.black)
                            .padding(.horizontal, Theme.buttonPadding)
                    }
                    
                    // Description Field
                    if requestType == "Client" || isExpert {
                        Text("Description")
                            .padding(.horizontal, 40)
                            .padding(.vertical, 6)
                            .font(.headline)
                            .foregroundColor(Theme.primaryColor)
                            .cornerRadius(30)
                        TextField("Provide a brief description", text: $description)
                            .padding()
                            .background(Theme.accentColor)
                            .cornerRadius(Theme.cornerRadius)
                            .font(Theme.inputFont)
                            .foregroundColor(.black)
                            .padding(.horizontal, Theme.buttonPadding)
                    }
                    
                    // Price Field
                    Text("Price")
                        .padding(.horizontal, 40)
                        .padding(.vertical, 6)
                        .font(.headline)
                        .foregroundColor(Theme.primaryColor)
                        .cornerRadius(30)
                    TextField("Enter a price", text: $price)
                        .keyboardType(.decimalPad)
                        .padding()
                        .background(Theme.accentColor)
                        .cornerRadius(Theme.cornerRadius)
                        .font(Theme.inputFont)
                        .foregroundColor(.black)
                        .padding(.horizontal, Theme.buttonPadding)
                    
                    HStack{
                        Text("Price Negotiable?")
                            .padding(.horizontal, 40)
                            .padding(.vertical, 6)
                            .font(.headline)
                            .foregroundColor(Theme.primaryColor)
                            .cornerRadius(30)
                        
                        Spacer()
                        
                        Picker("", selection: $isNegotiable) {
                            ForEach(dropdownUrgent, id: \.self) { option in
                                Text(option).tag(option)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                        .padding(.horizontal, 12)
                        .background(Theme.accentColor)
                        .foregroundStyle(Theme.primaryColor)
                        .cornerRadius(30)
                        
                    }
                    
                    // In-person
                    HStack{
                        Text("In-Person Availability")
                            .padding(.horizontal, 40)
                            .padding(.vertical, 6)
                            .font(.headline)
                            .foregroundColor(Theme.primaryColor)
                            .cornerRadius(30)
                        
                        Spacer()
                        
                        Picker("", selection: $inPerson) {
                            ForEach(dropdownOptions, id: \.self) { option in
                                Text(option).tag(option)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                        .padding(.horizontal, 12)
                        .background(Theme.accentColor)
                        .foregroundStyle(Theme.primaryColor)
                        .cornerRadius(30)
                    }
                    
                    // Online
                    HStack{
                        Text("Online Availability")
                            .padding(.horizontal, 40)
                            .padding(.vertical, 6)
                            .font(.headline)
                            .foregroundColor(Theme.primaryColor)
                            .cornerRadius(30)
                        
                        Spacer()
                        
                        Picker("", selection: $online) {
                            ForEach(dropdownOptions, id: \.self) { option in
                                Text(option).tag(option)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                        .padding(.horizontal, 12)
                        .background(Theme.accentColor)
                        .foregroundStyle(Theme.primaryColor)
                        .cornerRadius(30)
                    }
                    if (requestType != "Expert"){
                        HStack{
                            Text("Is it urgent?")
                                .padding(.horizontal, 40)
                                .padding(.vertical, 6)
                                .font(.headline)
                                .foregroundColor(Theme.primaryColor)
                                .cornerRadius(30)
                            
                            Spacer()
                            
                            Picker("", selection: $isUrgent) {
                                ForEach(dropdownUrgent, id: \.self) { option in
                                    Text(option).tag(option)
                                }
                            }
                            .pickerStyle(MenuPickerStyle())
                            .padding(.horizontal, 12)
                            .background(Theme.accentColor)
                            .foregroundStyle(Theme.primaryColor)
                            .cornerRadius(30)
                        }
                    }
                    if showError {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .multilineTextAlignment(.center)
                    }
                    Spacer()
                    // Post Job Button
                    Button(action: postJob) {
                        Text("Post")
                            .frame(maxWidth: .infinity)
                            .font(.headline)
                            .padding()
                            .background(Theme.accentColor)
                            .foregroundColor(Theme.primaryColor)
                            .cornerRadius(30)
                    }

                    // Cancel Button
                    Button(action: {
                        dismiss()
                    }) {
                        Text("Cancel")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Theme.accentColor)
                            .foregroundColor(Theme.primaryColor)
                            .cornerRadius(30)
                    }
                }
                .padding()
            }
            .navigationTitle("Post Job")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .background(Theme.accentColor.opacity(0.2))
//            .background(LinearGradient(
//                gradient: Gradient(colors: [.cyan.opacity(0.6), Theme.accentColor.opacity(0.6)]),
//                startPoint: .top,
//                endPoint: .bottom
//            ))
            .onAppear(perform: fetchUserProfile) // Fetch the user's profile
        }
        .navigationBarHidden(true)
    }

    // Function to post request job to the DB
    private func postJob() {
        guard let currentUser = Auth.auth().currentUser else {
            showError = true
            errorMessage = "You must be logged in to post a job."
            return
        }

        let db = Firestore.firestore()
        let userDocRef = db.collection("UserProfiles").document(currentUser.uid)

        // Fetch the user's firstName and lastName
        userDocRef.getDocument { document, error in
            if let document = document, document.exists {
                guard let data = document.data(),
                      let firstName = data["firstName"] as? String,
                      let lastName = data["lastName"] as? String else {
                    showError = true
                    errorMessage = "Failed to fetch user profile."
                    return
                }

                // Concatenate the full name
                let name = firstName + " " + lastName

                // Validate inputs
                guard !title.isEmpty, !address.isEmpty, !description.isEmpty, !price.isEmpty else {
                    showError = true
                    errorMessage = "Please fill out the required fields."
                    return
                }

                // Create the job data
                let jobData: [String: Any] = [
                    "UserID": currentUser.uid,
                    "Username": currentUser.email ?? "Unknown",
                    "TimeStamp": Timestamp(),
                    "Name": name,
                    "Title": title,
                    "Address": address,
                    "Description": description,
                    "Price": Double(price) ?? 0.0,
                    "PriceNegotiable": isNegotiable,
                    "InPerson": inPerson,
                    "Online": online,
                    "Urgency": requestType == "Expert" ? "No" : isUrgent,
                    "RequestType": requestType,
                    "Expertise": requestType == "Expert" ? expertise : []
                ]

                // Determine the collection to use
                let collectionName = requestType == "Expert" ? "ExpertRequest" : "ClientRequest"

                // Add the job data to Firestore
                db.collection(collectionName).addDocument(data: jobData) { error in
                    if let error = error {
                        showError = true
                        errorMessage = "Failed to post job: \(error.localizedDescription)"
                    } else {
                        dismiss() // Close the view on success
                    }
                }
            } else {
                showError = true
                errorMessage = "Failed to fetch user profile: \(error?.localizedDescription ?? "Unknown error")"
            }
        }
    }

    private func handleFirestoreResult(_ error: Error?) {
        if let error = error {
            showError = true
            errorMessage = "Failed to post job: \(error.localizedDescription)"
        } else {
            dismiss() // Close the view on success
        }
    }

    // Function to pull user information from UserProfile Collection (table) DB
    private func fetchUserProfile() {
        guard let currentUser = Auth.auth().currentUser else { return }

        let db = Firestore.firestore()
        let userDocRef = db.collection("UserProfiles").document(currentUser.uid)

        userDocRef.getDocument { document, error in
            if let document = document, document.exists {
                let data = document.data()
                self.isExpert = data?["isExpert"] as? Bool ?? false
                self.expertise = data?["expertCategories"] as? [String] ?? []
                self.requestType = self.isExpert ? "Expert" : "Client" // Default based on `isExpert`
            }
        }
    }
}

#Preview {
    PostJobView()
}

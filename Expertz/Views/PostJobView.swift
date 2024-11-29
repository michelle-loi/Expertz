import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct PostJobView: View {
    @State private var isExpert: Bool = false // Determines if the user is an expert
    @State private var requestType: String = "Client" // Default to Client
    @State private var title: String = ""
    @State private var description: String = ""
    @State private var address: String = ""
    @State private var inPerson: String = "Yes" // Dropdown default
    @State private var online: String = "Yes" // Dropdown default
    @State private var expertise: [String] = [] // Pulled from user profile
    @State private var price: String = ""
    @State private var isNegotiable: Bool = false
    @State private var isUrgent: Bool = false
    @State private var showError: Bool = false
    @State private var errorMessage: String = ""
    @Environment(\.dismiss) var dismiss // To dismiss the view

    let dropdownOptions = ["Yes", "No", "Only"]
    let dropdownUrgent = ["Yes", "No"]

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
                        .customFormInputField()

                    // Description Field
                    if requestType == "Client" || isExpert {
                        Text("Description")
                            .padding(.horizontal, 40)
                            .padding(.vertical, 6)
                            .font(.headline)
                            .foregroundColor(Theme.primaryColor)
                            .cornerRadius(30)
                        TextField("Provide a brief description", text: $description)
                            .customFormInputField()
                    }

                    // Address Field
                    if requestType == "Client" || isExpert {
                        Text("Address")
                            .padding(.horizontal, 40)
                            .padding(.vertical, 6)
                            .font(.headline)
                            .foregroundColor(Theme.primaryColor)
                            .cornerRadius(30)
                        TextField("Enter an address", text: $address)
                            .customFormInputField()
                    }

                    // Fields for ExpertRequest
                    
                    // Price Field
                    Text("Price")
                        .padding(.horizontal, 40)
                        .padding(.vertical, 6)
                        .font(.headline)
                        .foregroundColor(Theme.primaryColor)
                        .cornerRadius(30)
                    TextField("Enter a price", text: $price)
                        .keyboardType(.decimalPad)
                        .customFormInputField()
                    
                    if requestType == "Expert" && isExpert {
                        HStack{
                            Text("In-Person Availability")
                                .padding(.horizontal, 40)
                                .padding(.vertical, 6)
                                .font(.headline)
                                .foregroundColor(Theme.primaryColor)
                                .cornerRadius(30)
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

                        HStack{
                            Text("Online Availability")
                                .padding(.horizontal, 40)
                                .padding(.vertical, 6)
                                .font(.headline)
                                .foregroundColor(Theme.primaryColor)
                                .cornerRadius(30)
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
                    }
                        
                    if (requestType != "Expert"){
                        HStack{
                            Text("Is it urgent?")
                                .padding(.horizontal, 40)
                                .padding(.vertical, 6)
                                .font(.headline)
                                .foregroundColor(Theme.primaryColor)
                                .cornerRadius(30)
                            Picker("", selection: $inPerson) {
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
            .onAppear(perform: fetchUserProfile) // Fetch the user's profile
        }
        .navigationBarHidden(true)
    }

    private func postJob() {
        guard let currentUser = Auth.auth().currentUser else {
            showError = true
            errorMessage = "You must be logged in to post a job."
            return
        }

        // Validate inputs
        guard !title.isEmpty, !price.isEmpty else {
            showError = true
            errorMessage = "Please fill out the required fields."
            return
        }

        let db = Firestore.firestore()
        let jobData: [String: Any]

        if requestType == "Client" || !isExpert {
            jobData = [
                "UserID": currentUser.uid,
                "Username": currentUser.email ?? "Unknown",
                "Title": title,
                "Description": description,
                "Address": address,
                "Price": Double(price) ?? 0.0,
                "IsUrgent": isUrgent,
                "PriceNegotiable": isNegotiable,
                "Timestamp": Timestamp()
            ]
            db.collection("ClientRequest").addDocument(data: jobData) { handleFirestoreResult($0) }
        } else {
            jobData = [
                "UserID": currentUser.uid,
                "Username": currentUser.email ?? "Unknown",
                "Title": title,
                "Description": description,
                "Address": address,
                "InPerson": inPerson,
                "Online": online,
                "Expertise": expertise, // This is now a list
                "Price": Double(price) ?? 0.0,
                "PriceNegotiable": isNegotiable,
                "Timestamp": Timestamp()
            ]
            db.collection("ExpertRequest").addDocument(data: jobData) { handleFirestoreResult($0) }
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

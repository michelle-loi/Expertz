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

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    Text("Post Request")
                        .font(.largeTitle)
                        .bold()

                    // Conditionally show the request type picker if the user is an expert
                    if isExpert {
                        Text("Request Type")
                            .font(.headline)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Picker("", selection: $requestType) {
                            Text("Client").tag("Client")
                            Text("Expert").tag("Expert")
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .padding(.horizontal)
                    }

                    // Title Field
                    Text("Title")
                        .font(.headline)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    TextField("Enter a title for your request", text: $title)
                        .customFormInputField()

                    // Description Field
                    if requestType == "Client" || isExpert {
                        Text("Description")
                            .font(.headline)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        TextField("Provide a brief description", text: $description)
                            .customFormInputField()
                    }

                    // Address Field
                    if requestType == "Client" || isExpert {
                        Text("Address")
                            .font(.headline)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        TextField("Enter an address", text: $address)
                            .customFormInputField()
                    }

                    // Fields for ExpertRequest
                    if requestType == "Expert" && isExpert {
                        HStack{
                            Text("In-Person Availability")
                                .font(.headline)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            Picker("", selection: $inPerson) {
                                ForEach(dropdownOptions, id: \.self) { option in
                                    Text(option).tag(option)
                                }
                            }
                            .pickerStyle(MenuPickerStyle())
                            .padding()
                            .background(Color(.secondarySystemBackground))
                            .cornerRadius(10)
                        }

                        HStack{
                            Text("Online Availability")
                                .font(.headline)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            Picker("", selection: $online) {
                                ForEach(dropdownOptions, id: \.self) { option in
                                    Text(option).tag(option)
                                }
                            }
                            .pickerStyle(MenuPickerStyle())
                            .padding()
                            .background(Color(.secondarySystemBackground))
                            .cornerRadius(10)
                        }
                    }

                    // Price Field
                    Text("Price")
                        .font(.headline)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    TextField("Enter a price", text: $price)
                        .keyboardType(.decimalPad)
                        .customFormInputField()
                    
                    if (requestType != "Expert"){
                        // Price Negotiable Toggle
                        Toggle("Urgent Request", isOn: $isUrgent)
                            .toggleStyle(SwitchToggleStyle(tint: Theme.primaryColor))
                    }

                    // Price Negotiable Toggle
                    Toggle("Is the price negotiable?", isOn: $isNegotiable)
                        .toggleStyle(SwitchToggleStyle(tint: Theme.primaryColor))

                    if showError {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .multilineTextAlignment(.center)
                    }

                    // Post Job Button
                    Button(action: postJob) {
                        Text("Post Job")
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Theme.primaryColor)
                            .cornerRadius(10)
                    }
                    .padding(.horizontal)

                    // Cancel Button
                    Button(action: {
                        dismiss()
                    }) {
                        Text("Cancel")
                            .foregroundColor(.blue)
                    }
                }
                .padding()
            }
            .navigationTitle("Post Job")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .onAppear(perform: fetchUserProfile) // Fetch the user's profile
        }
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

//
//  ViewRequests.swift
//  Expertz
//
//  Created by Alan Huynh on 2024-11-27.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct ViewRequests: View {
    @State private var isExpert: Bool = false                   // Determines if the user is an expert
    @State private var selectedRequestType: String = "Client"   // Default to Client
    @State private var clientRequests: [Request] = []           // List of Client Requests
    @State private var expertRequests: [Request] = []           // List of Expert Requests
    @State private var showError: Bool = false
    @State private var errorMessage: String = ""
    @State private var isLoading: Bool = true

    var body: some View {
        NavigationStack {
            VStack {

                // Conditionally show the segmented control if the user is an expert
                if isExpert {
                    Picker("Request Type", selection: $selectedRequestType) {
                        Text("Client Requests").tag("Client")
                        Text("Expert Requests").tag("Expert")
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .foregroundStyle(Theme.primaryColor)
                    .padding()
                }

//                if isLoading {
//                    ProgressView("Loading requests...")
//                        .padding()
//                } else
                if showError {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding()
                } else {
                    ScrollView {
                        if selectedRequestType == "Client" || !isExpert {
                            // Display Client Requests
                            ForEach(clientRequests) { request in
                                RequestCard(request: request)
                            }
                        } else {
                            // Display Expert Requests
                            ForEach(expertRequests) { request in
                                RequestCard(request: request)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Your Requests")
            .navigationBarTitleDisplayMode(.inline)
            .background(LinearGradient(
                gradient: Gradient(colors: [.cyan.opacity(0.6), Theme.accentColor.opacity(0.6)]),
                startPoint: .top,
                endPoint: .bottom
            )
            // ignores safe border edges
            .ignoresSafeArea())
            .onAppear(perform: fetchRequests)
            .onChange(of: selectedRequestType) {
                fetchRequests()
            }
        }
    }

    private func fetchRequests() {
        guard let currentUser = Auth.auth().currentUser else {
            showError = true
            errorMessage = "You must be logged in to view requests."
            isLoading = false
            return
        }
        isLoading = true
        let db = Firestore.firestore()

        // Fetch user's profile to determine if they are an expert
        db.collection("UserProfiles").document(currentUser.uid).getDocument { document, error in
            if let document = document, document.exists {
                let data = document.data()
                self.isExpert = data?["isExpert"] as? Bool ?? false
            } else {
                showError = true
                errorMessage = "Failed to fetch user profile: \(error?.localizedDescription ?? "Unknown error")"
            }

            // Fetch Client Requests
            if self.selectedRequestType == "Client" || !self.isExpert {
                db.collection("ClientRequest")
                    .whereField("UserID", isEqualTo: currentUser.uid)
                    .getDocuments { snapshot, error in
                        if let error = error {
                            self.showError = true
                            self.errorMessage = "Failed to fetch client requests: \(error.localizedDescription)"
                        } else {
                            self.clientRequests = snapshot?.documents.compactMap { doc -> Request? in
                                var data = doc.data()
                                data["id"] = doc.documentID
                                
                                // Add defaults for missing fields
                                if data["Urgency"] == nil { data["Urgency"] = "No" }
                                if data["RequestType"] == nil { data["RequestType"] = "Expert" }
                                if data["Name"] == nil { data["Name"] = "Unknown" }
                                if data["Username"] == nil { data["Username"] = "Unknown" }
                                
                                return Request(data: data)
                            } ?? []
                        }
                        self.isLoading = false
                    }
            }

            // Fetch Expert Requests (only if applicable)
            if self.selectedRequestType == "Expert" && self.isExpert {
                db.collection("ExpertRequest")
                    .whereField("UserID", isEqualTo: currentUser.uid)
                    .getDocuments { snapshot, error in
                        if let error = error {
                            self.showError = true
                            self.errorMessage = "Failed to fetch expert requests: \(error.localizedDescription)"
                        } else {
                            self.expertRequests = snapshot?.documents.compactMap { doc -> Request? in
                                var data = doc.data()
                                data["id"] = doc.documentID
                                
                                // Add defaults for missing fields
                                if data["Urgency"] == nil { data["Urgency"] = "No" }
                                if data["RequestType"] == nil { data["RequestType"] = "Expert" }
                                if data["Name"] == nil { data["Name"] = "Unknown" }
                                if data["Username"] == nil { data["Username"] = "Unknown" }
                                
                                return Request(data: data)
                            } ?? []
                        }
                        self.isLoading = false
                        // debug
                        if let snapshot = snapshot {
                            for document in snapshot.documents {
                                print("Document data: \(document.data())") // Log all fields
                            }
                        } else if let error = error {
                            print("Error fetching documents: \(error.localizedDescription)")
                        }
                    }
            }
        }
    }
}

// MARK: - RequestCard View
struct RequestCard: View {
    let request: Request

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            // --Request Template-- //
            
            // Request Title
            Text("\(request.title)")
                .frame(maxWidth: .infinity)
                .foregroundColor(Theme.primaryColor)
                .cornerRadius(25)
                .font(.system(size: 20, weight: .bold))
            
            // Request Timestamp
            Text("\(request.timestamp)")
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(Theme.accentColor)
                .foregroundColor(Theme.primaryColor)
                .cornerRadius(25)
                .font(.system(size: 15, weight: .bold))
            
            // Request Address
            if let address = request.address {
                Text("Address: \(address)")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .background(Theme.accentColor)
                    .foregroundColor(Theme.primaryColor)
                    .cornerRadius(25)
                    .font(.system(size: 15, weight: .bold))
            }
            
            // Request Description
            Text("Description: \(request.description)")
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(Theme.accentColor)
                .foregroundColor(Theme.primaryColor)
                .cornerRadius(25)
                .font(.system(size: 15, weight: .bold))
            
            // Request Price
            Text("Price: $\(request.price, specifier: "%.2f")")
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(Theme.accentColor)
                .foregroundColor(Theme.primaryColor)
                .cornerRadius(25)
                .font(.system(size: 15, weight: .bold))
            
            // Request Urgency
            if let urgency = request.urgency {
                Text("Urgent: \(urgency)")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .background(Theme.accentColor)
                    .foregroundColor(Theme.primaryColor)
                    .cornerRadius(25)
                    .font(.system(size: 15, weight: .bold))
            }
            
            // Request Price Negotiable?
            if let isNegotiable = request.isNegotiable {
                Text("Negotiable: \(isNegotiable)")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .background(Theme.accentColor)
                    .foregroundColor(Theme.primaryColor)
                    .cornerRadius(25)
                    .font(.system(size: 15, weight: .bold))
            }
            
            // Request In-person
            if let inPerson = request.inPerson {
                Text("In-Person: \(inPerson)")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .background(Theme.accentColor)
                    .foregroundColor(Theme.primaryColor)
                    .cornerRadius(25)
                    .font(.system(size: 15, weight: .bold))
            }
            
            // Request Online
            if let online = request.online {
                Text("Online: \(online)")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .background(Theme.accentColor)
                    .foregroundColor(Theme.primaryColor)
                    .cornerRadius(25)
                    .font(.system(size: 15, weight: .bold))
            }
            
            // Request Expertises
            if let expertise = request.expertise, !expertise.isEmpty {
                Text("Expertise: \(expertise.joined(separator: ", "))") // Display as a comma-separated string
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .background(Theme.accentColor)
                    .foregroundColor(Theme.primaryColor)
                    .cornerRadius(25)
                    .font(.system(size: 15, weight: .bold))
            }
        }
        .padding()
        .background(Theme.primaryColor.opacity(0.5))
        .cornerRadius(25)
        .padding(.horizontal)
    }
}

// MARK: - Request Struct
struct Request: Identifiable {
    let name: String?
    let isNegotiable: String?
    let address: String?
    let expertise: [String]?
    let inPerson: String?
    let description: String
    let timestamp: String
    let username: String?
    let urgency: String?
    let online: String?
    let requestType: String?
    let id: String?
    let userID: String
    let title: String
    let price: Double

    init?(data: [String: Any]) {
        guard
//            let username = data["Username"] as? String,
            let userID = data["UserID"] as? String,
//            let requestType = data["RequestType"] as? String,
            let description = data["Description"] as? String,
            let title = data["Title"] as? String,
            let rawTimestamp = data["TimeStamp"] as? Timestamp,
//            let name = data["Name"] as? String,
            let price = data["Price"] as? Double
        else {
            print("Missing required fields: \(data)") // Log missing fields
            return nil
        }

        self.id = data["id"] as? String
        self.userID = userID
        self.title = title
        self.timestamp = DateFormatter.localizedString(
            from: rawTimestamp.dateValue(), // Convert Timestamp to Date
            dateStyle: .medium,
            timeStyle: .short
        )
        self.description = description
        self.address = data["Address"] as? String
        self.price = price
        self.urgency = data["Urgency"] as? String
        self.isNegotiable = data["PriceNegotiable"] as? String
        self.inPerson = data["InPerson"] as? String
        self.online = data["Online"] as? String
        self.expertise = data["Expertise"] as? [String]
        self.name = data["Name"] as? String
        self.requestType = data["RequestType"] as? String
        self.username = data["Username"] as? String
    }
}

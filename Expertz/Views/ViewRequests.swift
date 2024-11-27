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
    @State private var isExpert: Bool = false // Determines if the user is an expert
    @State private var selectedRequestType: String = "Client" // Default to Client
    @State private var clientRequests: [Request] = [] // List of Client Requests
    @State private var expertRequests: [Request] = [] // List of Expert Requests
    @State private var showError: Bool = false
    @State private var errorMessage: String = ""
    @State private var isLoading: Bool = true

    var body: some View {
        NavigationStack {
            VStack {
                // Debugging: Display isExpert state
                //Text("Is Expert: \(isExpert ? "Yes" : "No")")
                //    .font(.caption)
                //    .padding(.top, 10)
                //    .foregroundColor(.gray)

                // Conditionally show the segmented control if the user is an expert
                if isExpert {
                    Picker("Request Type", selection: $selectedRequestType) {
                        Text("Client Requests").tag("Client")
                        Text("Expert Requests").tag("Expert")
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding()
                }

                if isLoading {
                    ProgressView("Loading requests...")
                        .padding()
                } else if showError {
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
                                return Request(data: data)
                            } ?? []
                        }
                        self.isLoading = false
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
            Text("Title: \(request.title)")
                .font(.headline)
            Text("Description: \(request.description)")
                .font(.subheadline)
            if let address = request.address {
                Text("Address: \(address)")
                    .font(.subheadline)
            }
            Text("Price: $\(request.price, specifier: "%.2f")")
                .font(.subheadline)
            if let isUrgent = request.isUrgent {
                Text("Urgent: \(isUrgent ? "Yes" : "No")")
                    .font(.subheadline)
            }
            if let isNegotiable = request.isNegotiable {
                Text("Negotiable: \(isNegotiable ? "Yes" : "No")")
                    .font(.subheadline)
            }
            if let inPerson = request.inPerson {
                Text("In-Person: \(inPerson)")
                    .font(.subheadline)
            }
            if let online = request.online {
                Text("Online: \(online)")
                    .font(.subheadline)
            }
            if let expertise = request.expertise {
                Text("Expertise: \(expertise)")
                    .font(.subheadline)
            }
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(10)
        .padding(.horizontal)
    }
}

// MARK: - Request Struct
struct Request: Identifiable {
    let id: String
    let title: String
    let description: String
    let address: String?
    let price: Double
    let isUrgent: Bool?
    let isNegotiable: Bool?
    let inPerson: String?
    let online: String?
    let expertise: String?

    init?(data: [String: Any]) {
        guard let id = data["id"] as? String,
              let title = data["Title"] as? String,
              let description = data["Description"] as? String,
              let price = data["Price"] as? Double else { return nil }

        self.id = id
        self.title = title
        self.description = description
        self.address = data["Address"] as? String
        self.price = price
        self.isUrgent = data["IsUrgent"] as? Bool
        self.isNegotiable = data["PriceNegotiable"] as? Bool
        self.inPerson = data["InPerson"] as? String
        self.online = data["Online"] as? String
        self.expertise = data["Expertise"] as? String
    }
}

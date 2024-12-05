//
//  Homepage.swift
//  Expertz
//
//  Created by Alan Huynh on 2024-10-13.
//
//  - Functionality: APPLICATION MAIN PAGE
//      - Primary orgin for most nested view pages created
//      - logic from nested view pages stem from here
//      - General page for users
//      - intital page when app opens if logged in
//      - If user is logged in, navigation should be centered here

import SwiftUI
import MapKit
import CoreLocation
import FirebaseAuth

struct MapBubble: Identifiable {
    let name: String
    let id: String
    let coordinate: CLLocationCoordinate2D
    let type: String
    let help: String?
    let rating: String
    let description: String?
    let expertise: String?
    let bio: String?
    let urgent: String?
    let inPerson: String?
    let online: String?
    let negotiable: String?
    let price: String?
}

// General Page
struct Homepage: View {
    @Environment(\.dismiss) var dismiss
    @State private var showPostJobView: Bool = false
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 51.0447, longitude: -114.0719),
        span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
    )

    @State private var selectedAnnotation: MapBubble?
    @State private var selectedPickerOption = "Client"

    @State private var navigateToMessages = false
    @State private var navigateToChatroom = false // Debugging
    @State private var outerChatId = ""
    @State private var outerRecipientName = ""
    @State private var showPostPopup = false
    @State private var navigateToSettings = false
    @State private var isUrgent = false
    @State private var isNegotiable = false
    @State private var navigateToProfile = false
    @State private var navigateToRequests = false
    @State private var navigateToIntroduction = false

    //List of bubbles to append to
    var bubbles: [MapBubble] = []

    //Function to convert an address to coordinates
    func getCoordinate(addressString: String, completionHandler: @escaping (CLLocationCoordinate2D, NSError?) -> Void) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(addressString) { (placemarks, error) in
            if let error = error {
                completionHandler(kCLLocationCoordinate2DInvalid, error as NSError)
            } else if let placemark = placemarks?.first, let location = placemark.location {
                completionHandler(location.coordinate, nil)
            }
        }
    }

    var body: some View {
        NavigationStack {
            ZStack {
                // Custom Map View:
                CustomMapView(
                    region: $region,
                    selectedPickerOption: selectedPickerOption,
                    selectedAnnotation: $selectedAnnotation
                )
                .ignoresSafeArea()
                
                // Search Bar VStack
                VStack {
                    SearchBarView(selectedPickerOption: $selectedPickerOption)
                    Spacer()
                }
                
                // Bottom Nav Bar VStack
                VStack {
                    Spacer()
                    // Bottom Navigation Bar View
                    BottomNavigationBar(
                        navigateToMessages: $navigateToMessages,
                        navigateToSettings: $navigateToSettings,
                        navigateToProfile: $navigateToProfile,
                        navigateToRequests: $navigateToRequests,
                        showPostJobView: $showPostJobView
                    )
                    // Navigation Destinations
                    .navigationDestination(isPresented: $navigateToMessages) {
                        Messages()
                    }
                    .navigationDestination(isPresented: $navigateToSettings) {
                        Settings()
                    }
                    .navigationDestination(isPresented: $showPostJobView) {
                        PostJobView() // Navigate to the new PostJobView
                    }
                    .navigationDestination(isPresented: $navigateToProfile) {
                        AccountPage()
                    }
                    .navigationDestination(isPresented: $navigateToRequests) {
                        ViewRequests()
                    }
                    .toolbar(.hidden)
                }
                
                // Annotation Detail View
                AnnotationDetail(selectedAnnotation: $selectedAnnotation, navigateToChatroom: $navigateToChatroom, outerChatId: $outerChatId, outerRecipientName: $outerRecipientName)
            }
        }
        .onAppear {
            print("HomePage - onAppear called")
            checkLoginStatus()
        }
        .navigationDestination(isPresented: $navigateToIntroduction) {
            Introduction()
        }
        .navigationDestination(isPresented: $navigateToChatroom) {
            ChatRoom(chatId: outerChatId, recipientName: outerRecipientName)
        }
    }
    private func checkLoginStatus() {
        print("checkLoginStatus called")
        if Auth.auth().currentUser == nil {
            print("user nil")
            navigateToIntroduction = true
        } else {
            print("user logged in")
        }
    }
}

#Preview {
    Homepage()
}

//
//  CustomMap.swift
//  Expertz
//
//  Created by Alan Huynh on 2024-11-29.
//

import SwiftUI
import MapKit
import CoreLocation
import FirebaseFirestore

struct CustomMapView: View {
    @Binding var region: MKCoordinateRegion
    let selectedPickerOption: String
    @Binding var selectedAnnotation: MapBubble?

    @State private var clientBubbles: [MapBubble] = []
    @State private var expertBubbles: [MapBubble] = []
    @State private var isLoading: Bool = true

    var body: some View {
        Map(coordinateRegion: $region, annotationItems: selectedPickerOption == "Client" ? clientBubbles : expertBubbles) { bubble in
            MapAnnotation(coordinate: bubble.coordinate) {
                Button(action: {
                    selectedAnnotation = bubble
                }) {
                    Circle()
                        .fill(selectedPickerOption == "Client" ? Theme.accentColor : Theme.accentColor) // Different colors for Client/Expert
                        .frame(width: 30, height: 30)
                        .overlay(
                            Circle()
                                .stroke(Color.white, lineWidth: 2)
                            )
                        .shadow(radius: 3)
                }
            }
        }
        .onAppear {
            fetchData()
        }
    }

    // Function to fetch data for both Client and Expert requests
    func fetchData() {
        fetchClientRequests()
        fetchExpertRequests()
    }

    // Function to fetch ClientRequest data from Firestore
    func fetchClientRequests() {
        let db = Firestore.firestore()
        db.collection("ClientRequest").getDocuments { (snapshot, error) in
            guard let documents = snapshot?.documents else {
                print("No ClientRequest documents found")
                return
            }
            for document in documents {
                let data = document.data()
                let address = data["Address"] as? String ?? ""

                // Convert address to coordinates
                getCoordinate(addressString: address) { coordinate, error in
                    if let coordinate = coordinate, error == nil {
                        // Create MapBubble instance
                        let name = data["Name"] as? String ?? "Unknown"
                        let title = data["Title"] as? String ?? ""
                        let description = data["Description"] as? String ?? ""
                        let price = data["Price"] as? Double ?? 0.0
                        let priceString = String(format: "%.2f", price)
                        let negotiable = data["PriceNegotiable"] as? String ?? "No"
                        let urgent = data["Urgency"] as? Bool ?? false
                        let urgentString = urgent ? "Yes" : "No"
                        let inPerson = data["InPerson"] as? String ?? ""
                        let online = data["Online"] as? String ?? ""

                        let mapBubble = MapBubble(
                            name: name,
                            coordinate: coordinate,
                            type: "Client",
                            help: title,
                            rating: "0.0", // Initialize to 0 or fetch from your ratings system
                            description: description,
                            expertise: nil, // Expertise is hidden for Client requests
                            bio: nil, // Not applicable
                            urgent: urgentString,
                            negotiable: negotiable,
                            price: "$\(priceString)"
                        )

                        // Update UI on main thread
                        DispatchQueue.main.async {
                            clientBubbles.append(mapBubble)
                        }
                    } else {
                        print("Error getting coordinate for address \(address): \(error?.localizedDescription ?? "Unknown error")")
                    }
                }
            }
        }
    }

    // Function to fetch ExpertRequest data from Firestore
    func fetchExpertRequests() {
        let db = Firestore.firestore()
        db.collection("ExpertRequest").getDocuments { (snapshot, error) in
            guard let documents = snapshot?.documents else {
                print("No ExpertRequest documents found")
                return
            }
            for document in documents {
                let data = document.data()
                let address = data["Address"] as? String ?? ""

                // Convert address to coordinates
                getCoordinate(addressString: address) { coordinate, error in
                    if let coordinate = coordinate, error == nil {
                        // Create MapBubble instance
                        let name = data["Name"] as? String ?? "Unknown"
                        let title = data["Title"] as? String ?? ""
                        let description = data["Description"] as? String ?? ""
                        let price = data["Price"] as? Double ?? 0.0
                        let priceString = String(format: "%.2f", price)
                        let negotiable = data["PriceNegotiable"] as? String ?? "No"
                        let inPerson = data["InPerson"] as? String ?? ""
                        let online = data["Online"] as? String ?? ""
                        let expertiseArray = data["Expertise"] as? [String] ?? []
                        let expertiseString = expertiseArray.joined(separator: ", ")

                        let mapBubble = MapBubble(
                            name: name,
                            coordinate: coordinate,
                            type: "Expert",
                            help: title,
                            rating: "0.0", // Initialize to 0 or fetch from your ratings system
                            description: description,
                            expertise: expertiseString,
                            bio: nil, // If you have a bio field, you can fetch it here
                            urgent: nil, // Urgency is hidden for Expert requests
                            negotiable: negotiable,
                            price: "$\(priceString)"
                        )

                        // Update UI on main thread
                        DispatchQueue.main.async {
                            expertBubbles.append(mapBubble)
                        }
                    } else {
                        print("Error getting coordinate for address \(address): \(error?.localizedDescription ?? "Unknown error")")
                    }
                }
            }
        }
    }

    // Function to convert address string to CLLocationCoordinate2D
    func getCoordinate(addressString: String, completionHandler: @escaping (CLLocationCoordinate2D?, Error?) -> Void ) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(addressString) { (placemarks, error) in
            if let error = error {
                completionHandler(nil, error)
                return
            }
            if let coordinate = placemarks?.first?.location?.coordinate {
                completionHandler(coordinate, nil)
            } else {
                completionHandler(nil, NSError(domain: "GeocodingError", code: 0, userInfo: [NSLocalizedDescriptionKey: "No coordinate found"]))
            }
        }
    }
}

//struct CustomMapView: View {
//    @Binding var region: MKCoordinateRegion
//    let selectedPickerOption: String
//    @Binding var selectedAnnotation: MapBubble?
//
//    let clientBubbles = [
//        MapBubble(name: "Jessica", coordinate: CLLocationCoordinate2D(latitude: 51.045, longitude: -114.07), type: "Client", help: "Japanese Translation", rating: "3.2", description: "I need help with some document translation to Japanese", expertise: nil, bio: nil, urgent: "Yes", negotiable: "Yes", price: "$500"),
//        MapBubble(name: "Jack", coordinate: CLLocationCoordinate2D(latitude: 51.046, longitude: -114.08), type: "Client", help: "Learning Guitar", rating: "4.0", description: "I need help with learning the guitar.", expertise: nil, bio: nil, urgent: "Yes", negotiable: "Yes", price: "$200"),
//        MapBubble(name: "James", coordinate: CLLocationCoordinate2D(latitude: 51.044, longitude: -114.06), type: "Client", help: "Logo Design", rating: "2.8", description: "I need help with the logo of my show company", expertise: nil, bio: nil, urgent: "No", negotiable: "No", price: "$135"),
//        MapBubble(name: "Mark", coordinate: CLLocationCoordinate2D(latitude: 51.043, longitude: -114.075), type: "Client", help: "Learning French", rating: "3.5", description: "I need help with learning french for exam", expertise: nil, bio: nil, urgent: "Yes", negotiable: "No", price: "$60"),
//        MapBubble(name: "Rose", coordinate: CLLocationCoordinate2D(latitude: 51.047, longitude: -114.065), type: "Client", help: "Home Maintenance", rating: "4.9", description: "I need help with home maintenance in my bathroom.", expertise: nil, bio: nil, urgent: "No", negotiable: "Yes", price: "$55"),
//    ]
//
//    // Example coordinates for Expert bubbles
//    let expertBubbles = [
//        MapBubble(name: "Cassie", coordinate: CLLocationCoordinate2D(latitude: 51.05, longitude: -114.07), type: "Expert", help: nil, rating: "3.9", description: nil, expertise: "3D Art", bio: "I know how to do 3D work in Blender", urgent: nil, negotiable: nil, price: nil),
//        MapBubble(name: "Micheal", coordinate: CLLocationCoordinate2D(latitude: 51.051, longitude: -114.08), type: "Expert", help: nil, rating: "4.7", description: nil, expertise: "Plumbing", bio: "I can help with plumbing in your home.", urgent: nil, negotiable: nil, price: nil),
//        MapBubble(name: "Leslie", coordinate: CLLocationCoordinate2D(latitude: 51.049, longitude: -114.06), type: "Expert", help: nil, rating: "3.0", description: nil, expertise: "Professional Guitarist", bio: "I can teach you how to play the guitar both online and in-person.", urgent: nil, negotiable: nil, price: nil),
//        MapBubble(name: "Margaret", coordinate: CLLocationCoordinate2D(latitude: 51.048, longitude: -114.075), type: "Expert", help: nil, rating: "4.9", description: nil, expertise: "French Teacher", bio: "I can teach you the french language.", urgent: nil, negotiable: nil, price: nil),
//        MapBubble(name: "Frank", coordinate: CLLocationCoordinate2D(latitude: 51.052, longitude: -114.065), type: "Expert", help: nil, rating: "2.5", description: nil, expertise: "Carpenter", bio: "I can help you with any wood work in your house or personalized wood objects.", urgent: nil, negotiable: nil, price: nil),
//    ]
//
//    var body: some View {
//        Map(coordinateRegion: $region, annotationItems: selectedPickerOption == "Client" ? clientBubbles : expertBubbles) { bubble in
//            MapAnnotation(coordinate: bubble.coordinate) {
//                Button(action: {
//                    selectedAnnotation = bubble
//                }) {
//                    Circle()
//                        .fill(selectedPickerOption == "Client" ? Theme.accentColor : Theme.accentColor) // Different colors for Client/Expert
//                        .frame(width: 30, height: 30)
//                        .overlay(
//                            Circle()
//                                .stroke(Color.white, lineWidth: 2)
//                        )
//                        .shadow(radius: 3)
//                }
//            }
//        }
//        .ignoresSafeArea()
//    }
//}
//

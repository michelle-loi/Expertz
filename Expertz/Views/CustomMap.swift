//  - Nested View Component for Homepage View
//  - Pulling parameters from Homepage to
//  - View used convert address string from DB to coordinates
//  - View also used to distinguish between client and expert request
//  - to create clickable coordinate bubbles on Map
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
                        .fill(Theme.primaryColor.opacity(0.5))
                        .frame(width: 50, height: 50)
                        .overlay(
                            Circle()
                                .stroke(Color.white, lineWidth: 2)
                        )
                        .shadow(radius: 5)

                }
            }
        }
        .onAppear {
            fetchData()
        }
    }

    // Function to fetch data for both Client and Expert requests
    func fetchData() {
        // Clear existing bubbles
        clientBubbles.removeAll()
        expertBubbles.removeAll()
        
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
                        let id = data["UserID"] as? String ?? ""
                        let title = data["Title"] as? String ?? ""
                        let description = data["Description"] as? String ?? ""
                        let price = data["Price"] as? Double ?? 0.0
                        let priceString = String(format: "%.2f", price)
                        let negotiable = data["PriceNegotiable"] as? String ?? "No"
                        let urgent = data["Urgency"] as? String ?? ""
                        let inPerson = data["InPerson"] as? String ?? ""
                        let online = data["Online"] as? String ?? ""

                        let mapBubble = MapBubble(
                            name: name,
                            id: id,
                            coordinate: coordinate,
                            type: "Client",
                            help: title,
                            rating: "0.0",
                            description: description,
                            expertise: nil, // Expertise is hidden for Client requests
                            bio: nil, // Not applicable for client requests
                            urgent: urgent,
                            inPerson: inPerson,
                            online: online,
                            negotiable: negotiable,
                            price: "$\(priceString)/hr"
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
                        let id = data["UserID"] as? String ?? ""
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
                            id: id,
                            coordinate: coordinate,
                            type: "Expert",
                            help: title,
                            rating: "0.0",
                            description: description,
                            expertise: expertiseString,
                            bio: nil, // nil until implemented later
                            urgent: nil, // Urgency is hidden for Expert requests
                            inPerson: inPerson,
                            online: online,
                            negotiable: negotiable,
                            price: "$\(priceString)/hr"
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


//
//  CustomMap.swift
//  Expertz
//
//  Created by Alan Huynh on 2024-11-29.
//

import SwiftUI
import MapKit
import CoreLocation

struct CustomMapView: View {
    @Binding var region: MKCoordinateRegion
//    let clientBubbles: [MapBubble]
//    let expertBubbles: [MapBubble]
    let selectedPickerOption: String
//    var bubbles: [MapBubble] = []
    @Binding var selectedAnnotation: MapBubble?

    let clientBubbles = [
        MapBubble(name: "Jessica", coordinate: CLLocationCoordinate2D(latitude: 51.045, longitude: -114.07), type: "Client", help: "Japanese Translation", rating: "3.2", description: "I need help with some document translation to Japanese", expertise: nil, bio: nil, urgent: "Yes", negotiable: "Yes", price: "$500"),
        MapBubble(name: "Jack", coordinate: CLLocationCoordinate2D(latitude: 51.046, longitude: -114.08), type: "Client", help: "Learning Guitar", rating: "4.0", description: "I need help with learning the guitar.", expertise: nil, bio: nil, urgent: "Yes", negotiable: "Yes", price: "$200"),
        MapBubble(name: "James", coordinate: CLLocationCoordinate2D(latitude: 51.044, longitude: -114.06), type: "Client", help: "Logo Design", rating: "2.8", description: "I need help with the logo of my show company", expertise: nil, bio: nil, urgent: "No", negotiable: "No", price: "$135"),
        MapBubble(name: "Mark", coordinate: CLLocationCoordinate2D(latitude: 51.043, longitude: -114.075), type: "Client", help: "Learning French", rating: "3.5", description: "I need help with learning french for exam", expertise: nil, bio: nil, urgent: "Yes", negotiable: "No", price: "$60"),
        MapBubble(name: "Rose", coordinate: CLLocationCoordinate2D(latitude: 51.047, longitude: -114.065), type: "Client", help: "Home Maintenance", rating: "4.9", description: "I need help with home maintenance in my bathroom.", expertise: nil, bio: nil, urgent: "No", negotiable: "Yes", price: "$55"),
    ]

    // Example coordinates for Expert bubbles
    let expertBubbles = [
        MapBubble(name: "Cassie", coordinate: CLLocationCoordinate2D(latitude: 51.05, longitude: -114.07), type: "Expert", help: nil, rating: "3.9", description: nil, expertise: "3D Art", bio: "I know how to do 3D work in Blender", urgent: nil, negotiable: nil, price: nil),
        MapBubble(name: "Micheal", coordinate: CLLocationCoordinate2D(latitude: 51.051, longitude: -114.08), type: "Expert", help: nil, rating: "4.7", description: nil, expertise: "Plumbing", bio: "I can help with plumbing in your home.", urgent: nil, negotiable: nil, price: nil),
        MapBubble(name: "Leslie", coordinate: CLLocationCoordinate2D(latitude: 51.049, longitude: -114.06), type: "Expert", help: nil, rating: "3.0", description: nil, expertise: "Professional Guitarist", bio: "I can teach you how to play the guitar both online and in-person.", urgent: nil, negotiable: nil, price: nil),
        MapBubble(name: "Margaret", coordinate: CLLocationCoordinate2D(latitude: 51.048, longitude: -114.075), type: "Expert", help: nil, rating: "4.9", description: nil, expertise: "French Teacher", bio: "I can teach you the french language.", urgent: nil, negotiable: nil, price: nil),
        MapBubble(name: "Frank", coordinate: CLLocationCoordinate2D(latitude: 51.052, longitude: -114.065), type: "Expert", help: nil, rating: "2.5", description: nil, expertise: "Carpenter", bio: "I can help you with any wood work in your house or personalized wood objects.", urgent: nil, negotiable: nil, price: nil),
    ]
    
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
        .ignoresSafeArea()
    }
}

/*
    //Function to add a bubble
    func addBubble(
        forAddress address: String,
        name: String,
        type: String,
        help: String,
        rating: String,
        description: String,
        expertise: String,
        bio: String,
        urgent: String,
        negotiable: String,
        price: String,
        to bubbles: inout [MapBubble]
    ) {
        getCoordinate(addressString: address) { coordinate, error in
            // If there is no error finding the location, create a bubble
            if let coordinate = coordinate, error == nil {
                let newBubble = MapBubble(
                    name: name,
                    coordinate: coordinate,
                    type: type,
                    help: help,
                    rating: rating,
                    description: description,
                    expertise: expertise,
                    bio: bio,
                    urgent: urgent,
                    negotiable: negotiable,
                    price: price
                )
                bubbles.append(newBubble)
            } else {
                //Error Finding Location
            }
        }
    }

*/

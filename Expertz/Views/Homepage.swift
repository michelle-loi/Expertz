//
//  Homepage.swift
//  Expertz
//
//  Created by Alan Huynh on 2024-10-13.
//

import SwiftUI
import MapKit
import CoreLocation

struct MapBubble: Identifiable {
    let id = UUID()
    let name: String
    let coordinate: CLLocationCoordinate2D
    let type: String
    let help: String?
    let rating: String
    let description: String?
    let expertise: String?
    let bio: String?
    let urgent: String?
    let negotiable: String?
    let price: String?
}

// General Page
struct Homepage: View {
    @State private var showPostJobView: Bool = false
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 51.0447, longitude: -114.0719),
        span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
    )

    @State private var selectedAnnotation: MapBubble?
    @State private var selectedPickerOption = "Client"

    @State private var navigateToMessages = false
    @State private var showPostPopup = false
    @State private var navigateToSettings = false
    @State private var isUrgent = false
    @State private var isNegotiable = false
    @State private var navigateToProfile = false
    @State private var navigateToRequests = false

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

    //Function to add a bubble
    //Usage: addBubble(forAddress: "address", to: &bubbles)
    func addBubble(forAddress address: String, to bubbles: inout [MapBubble]) {
        getCoordinate(addressString: address) { coordinate, error in
            //If there is no error finding the location. We create a bubble
            if error == nil {
                let newBubble = MapBubble(
                    name: //Placeholder,
                    coordinate: coordinate, //Pass in the coordinate from getCoordinate
                    type: //Placeholder,
                    help: //Placeholder,
                    rating: //Placeholder,
                    description: //Placeholder,
                    expertise: //Placeholder,
                    bio: //Placeholder,
                    urgent: //Placeholder,
                    negotiable: //Placeholder,
                    price: //Placeholder
                )
                bubbles.append(newBubble)
            } else {
                //Error finding location.
            }
        }
    }
    
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
        NavigationStack {
            ZStack {
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


                if showPostPopup {
                    VStack {
                        Spacer()
                        VStack(spacing: 15) {
                            TextField("Description", text: .constant(""))
                                .padding()
                                .background(Theme.accentColor.opacity(0.2))
                                .cornerRadius(13)
                            TextField("Address", text: .constant(""))
                                .padding()
                                .background(Theme.accentColor.opacity(0.2))
                                .cornerRadius(13)
                            TextField("Price", text: .constant(""))
                                .padding()
                                .background(Theme.accentColor.opacity(0.2))
                                .cornerRadius(30)
                            HStack {
                                Text("Urgent posting?")
                                    .font(.headline)
                                    .foregroundColor(Theme.primaryColor)
                                Spacer()
                                Toggle("", isOn: $isUrgent)
                                    .toggleStyle(SwitchToggleStyle(tint: Theme.primaryColor))
                            }
                            .padding()
                            .background(Theme.accentColor.opacity(0.2))
                            .cornerRadius(30)
                            HStack {
                                Text("Is price negotiable?")
                                    .font(.headline)
                                    .foregroundColor(Theme.primaryColor)
                                Spacer()
                                Toggle("", isOn: $isNegotiable)
                                    .toggleStyle(SwitchToggleStyle(tint: Theme.primaryColor))
                            }
                            .padding()
                            .background(Theme.accentColor.opacity(0.2))
                            .cornerRadius(30)
                            Button(action: { showPostPopup = false }) {
                                Text("Post")
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Theme.accentColor)
                                    .cornerRadius(30)
                            }
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(30)
                        .shadow(radius: 5)
                        .padding(.horizontal, 20)
                        Spacer()
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.black.opacity(0.4))
                    .ignoresSafeArea()
                }
                VStack {
                    ZStack {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Theme.accentColor)
                            .frame(height: 120)
                            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
                            .padding(.horizontal, 10)

                        VStack(spacing: 15) {
                            HStack {
                                TextField("Search for an expert...", text: .constant(""))
                                    .padding()
                                    .background(Theme.secondaryColor)
                                    .cornerRadius(15)
                                    .shadow(radius: 3)

                                Button(action: {}) {
                                    
                                    Image(systemName: "slider.horizontal.3")
                                        .foregroundColor(.white)
                                        .padding()
                                        .background(Theme.accentColor)
                                    
                                }
                            }
                            .padding(.horizontal)
                            Picker("", selection: $selectedPickerOption) {
                                Text("Client").tag("Client")
                                Text("Expert").tag("Expert")
                            }
                            .pickerStyle(SegmentedPickerStyle())
                            .padding(.horizontal)
                        }
                    }
                    .padding(.top, 10)
                    .padding(.bottom, 55)
                    Spacer()
                }
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        
                        Button(action: {navigateToMessages = true }) {
                            VStack(){
                                Image(systemName: "bubble.left.and.bubble.right")
                                    .foregroundColor(Theme.primaryColor)
                                    .background(Theme.accentColor)
                                Text("Messages")
                                .foregroundStyle(Theme.primaryColor)}
                        }
                        Button(action: {navigateToRequests = true }) {
                            VStack(){
                                Image(systemName: "person.crop.circle.badge.exclamationmark")
                                    .foregroundColor(Theme.primaryColor)
                                    .background(Theme.accentColor)
                                Text("Requests")
                                .foregroundStyle(Theme.primaryColor)}
                        }
                        Button(action: { showPostJobView.toggle() }) {
                            Circle()
                                .fill(Theme.primaryColor)
                                .frame(width: 45, height: 45)
                                .overlay(Image(systemName: "plus")
                                    .font(.system(size: 24))
                                    .foregroundColor(.white))
                        }
                        Button(action: {navigateToSettings = true }) {
                            VStack(){
                                Image(systemName: "gear")
                                    .foregroundColor(Theme.primaryColor)
                                    .background(Theme.accentColor)
                                Text("Settings")
                                .foregroundStyle(Theme.primaryColor)}
                        }
                        Button(action: {navigateToProfile = true }) {
                            VStack(){
                                Image(systemName: "person")
                                    .foregroundColor(Theme.primaryColor)
                                    .background(Theme.accentColor)
                                Text("Profile")
                                .foregroundStyle(Theme.primaryColor)}
                        }
                        Spacer()
                    }
                    .frame(height: 70)
                    .background(Theme.accentColor)
                    .cornerRadius(30)
                    .padding(.horizontal, 20)
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
                if let annotation = selectedAnnotation {
                    ZStack {
                        Rectangle()
                            .fill(Color.black.opacity(0.6))
                            .ignoresSafeArea()
                            .onTapGesture {
                                selectedAnnotation = nil      }
                            .zIndex(0)
                        if annotation.type == "Expert" {
                            VStack {
                                Spacer()
                                VStack(spacing: 10) {
                                    HStack(spacing: 10) {
                                        Circle()
                                            .fill(Color.gray)
                                            .frame(width: 50, height: 50)

                                        VStack(alignment: .leading) {
                                            Text("\(annotation.name),")
                                                .font(.headline)
                                                .foregroundColor(Theme.primaryColor)
                                            Text("An Expert in:")
                                                .font(.headline)
                                                .foregroundColor(Theme.primaryColor)
                                            Text("\(annotation.expertise ?? "N/A")")
                                                .font(.headline)
                                                .foregroundColor(Theme.accentColor)
                                        }
                                        Spacer()
                                        HStack(spacing: 5) {
                                            Text("\(annotation.rating)")
                                                .font(.headline)
                                                .foregroundColor(.black)
                                            Circle()
                                                .fill(Color.yellow)
                                                .frame(width: 20, height: 20)
                                        }
                                    }
                                    Text("\(annotation.bio ?? "Bio not available")")
                                        .font(.body)
                                        .foregroundColor(Theme.primaryColor)
                                        .multilineTextAlignment(.leading)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    HStack(spacing: 10) {
                                        ForEach(["Realism", "3D Design", "Unity"], id: \.self) { tag in
                                            Text(tag)
                                                .padding(.horizontal, 12)
                                                .padding(.vertical, 6)
                                                .background(Theme.accentColor.opacity(0.2))
                                                .foregroundColor(Theme.primaryColor)
                                                .cornerRadius(30)

                                        }
                                    }
                                    VStack(alignment: .leading, spacing: 10) {
                                        Text("Reviews:")
                                            .font(.headline)
                                            .foregroundColor(Theme.primaryColor)

                                        ScrollView(.horizontal, showsIndicators: false) {
                                            HStack(spacing: 15) {
                                                ForEach(0..<5) { index in
                                                    VStack(alignment: .leading) {
                                                        Text("Lorem ipsum dolor sit amet.")
                                                            .font(.body)
                                                            .foregroundColor(Theme.primaryColor)
                                                    }
                                                    .padding()
                                                    .frame(width: 200)
                                                    .background(Theme.accentColor.opacity(0.2))
                                                    .cornerRadius(30)
                                                }
                                            }
                                        }
                                    }
                                    TextField("Give a brief description", text: .constant(""))
                                        .padding()
                                        .background(Theme.accentColor.opacity(0.2))
                                        .foregroundColor(Theme.primaryColor)
                                        .cornerRadius(30)
                                    Button(action: {
                                        selectedAnnotation = nil
                                    }) {
                                        Text("Send a request")
                                            .foregroundColor(.white)
                                            .frame(maxWidth: .infinity)
                                            .padding()
                                            .background(Theme.accentColor)
                                            .cornerRadius(30)
                                    }
                                }
                                .padding()
                                .background(Color.white)
                                .cornerRadius(30)
                                .shadow(radius: 50)
                                .padding(.horizontal, 20)
                                Spacer(minLength: 5)
                            }
                            .zIndex(1)
                        }
                        if annotation.type == "Client" {
                            VStack {
                                Spacer()
                                VStack(spacing: 10) {
                                    HStack(spacing: 10) {
                                        Circle()
                                            .fill(Color.gray)
                                            .frame(width: 50, height: 50)

                                        VStack(alignment: .leading) {
                                            Text("\(annotation.name),")
                                                .font(.headline)
                                                .foregroundColor(Theme.primaryColor)
                                            Text("Needs help with:")
                                                .font(.headline)
                                                .foregroundColor(Theme.primaryColor)
                                            Text("\(annotation.help ?? "N/A")")
                                                .font(.headline)
                                                .foregroundColor(Theme.accentColor)

                                        }
                                        Spacer()
                                        HStack(spacing: 5) {
                                            Text("\(annotation.rating)")
                                                .font(.headline)
                                                .foregroundColor(.black)
                                            Circle()
                                                .fill(Color.yellow)
                                                .frame(width: 20, height: 20)
                                        }
                                    }
                                    Text("\(annotation.description ?? "No description available.")")
                                        .font(.body)
                                        .foregroundColor(Theme.primaryColor)
                                        .multilineTextAlignment(.leading)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    HStack() {
                                        Text("Urgency: ")
                                        if annotation.urgent == "No"{
                                            Text("No")
                                                .padding(.horizontal, 12)
                                                .padding(.vertical, 6)
                                                .background(Theme.accentColor.opacity(0.2))
                                                .foregroundColor(Theme.primaryColor)
                                                .cornerRadius(30)
                                        }
                                        if annotation.urgent == "Yes"{
                                            Text("Yes")
                                                .padding(.horizontal, 12)
                                                .padding(.vertical, 6)
                                                .background(Theme.accentColor.opacity(0.2))
                                                .foregroundColor(Theme.primaryColor)
                                                .cornerRadius(30)
                                        }
                                        Spacer()
                                    }
                                    HStack() {
                                        Text("Price: ")
                                        Text("\(annotation.price ?? "No price available.")")
                                            .padding(.horizontal, 12)
                                            .padding(.vertical, 6)
                                            .background(Theme.accentColor.opacity(0.2))
                                            .foregroundColor(Theme.primaryColor)
                                            .cornerRadius(30)

                                        if annotation.negotiable == "Yes"{
                                            Text("Negotiable")
                                                .padding(.horizontal, 12)
                                                .padding(.vertical, 6)
                                                .background(Theme.accentColor.opacity(0.2))
                                                .foregroundColor(Theme.primaryColor)
                                                .cornerRadius(30)
                                        }
                                        Spacer()
                                    }
                                    TextField("How much are you charging for this work?", text: .constant(""))
                                        .padding()
                                        .background(Theme.accentColor.opacity(0.2))
                                        .foregroundColor(Theme.primaryColor)
                                        .cornerRadius(30)
                                    Button(action: {
                                        selectedAnnotation = nil
                                    }) {
                                        Text("Notify the client")
                                            .foregroundColor(.white)
                                            .frame(maxWidth: .infinity)
                                            .padding()
                                            .background(Theme.accentColor)
                                            .cornerRadius(30)
                                    }
                                }
                                .padding()
                                .background(Color.white)
                                .cornerRadius(30)
                                .shadow(radius: 10)
                                .padding(.horizontal, 20)
                                Spacer(minLength: 5)
                            }
                            .zIndex(1)
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    Homepage()
}

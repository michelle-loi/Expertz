//
//  Homepage.swift
//  Expertz
//
//  Created by Alan Huynh on 2024-10-13.
//

import SwiftUI
import MapKit

struct MapBubble: Identifiable {
    let id = UUID() // Unique identifier
    let name: String
    let coordinate: CLLocationCoordinate2D
}

// General Page
struct Homepage: View {
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 51.0447, longitude: -114.0719), // Example coordinates for Calgary
        span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
    )

    @State private var selectedAnnotation: MapBubble? // State to track the selected bubble
    @State private var selectedPickerOption = "Client" // State for the Picker selection
    @State private var navigateToMessages = false // State for manual navigation

    // Example coordinates for Client bubbles
    let clientBubbles = [
        MapBubble(name: "Client 1", coordinate: CLLocationCoordinate2D(latitude: 51.045, longitude: -114.07)),
        MapBubble(name: "Client 2", coordinate: CLLocationCoordinate2D(latitude: 51.046, longitude: -114.08)),
        MapBubble(name: "Client 3", coordinate: CLLocationCoordinate2D(latitude: 51.044, longitude: -114.06)),
        MapBubble(name: "Client 4", coordinate: CLLocationCoordinate2D(latitude: 51.043, longitude: -114.075)),
        MapBubble(name: "Client 5", coordinate: CLLocationCoordinate2D(latitude: 51.047, longitude: -114.065))
    ]

    // Example coordinates for Expert bubbles
    let expertBubbles = [
        MapBubble(name: "Expert 1", coordinate: CLLocationCoordinate2D(latitude: 51.05, longitude: -114.07)),
        MapBubble(name: "Expert 2", coordinate: CLLocationCoordinate2D(latitude: 51.051, longitude: -114.08)),
        MapBubble(name: "Expert 3", coordinate: CLLocationCoordinate2D(latitude: 51.049, longitude: -114.06)),
        MapBubble(name: "Expert 4", coordinate: CLLocationCoordinate2D(latitude: 51.048, longitude: -114.075)),
        MapBubble(name: "Expert 5", coordinate: CLLocationCoordinate2D(latitude: 51.052, longitude: -114.065))
    ]

    var body: some View {
        NavigationStack {
            ZStack {
                // Map View with Conditional Bubbles
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

                // Popup for selected annotation
                if let selectedAnnotation = selectedAnnotation {
                    VStack {
                        Spacer()
                        VStack(spacing: 10) {
                            Text(selectedAnnotation.name)
                                .font(.headline)
                            Button("Close") {
                                self.selectedAnnotation = nil
                            }
                            .padding(.horizontal, 20)
                            .padding(.vertical, 10)
                            .background(Theme.accentColor)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(15)
                        .shadow(radius: 5)
                        .frame(width: 300)
                        Spacer()
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.black.opacity(0.4))
                    .ignoresSafeArea()
                }

                // Curved Background for Search Bar and Toggle
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
                                        .cornerRadius(15)
                                }
                            }
                            .padding(.horizontal)

                            // Picker with dynamic state binding
                            Picker("", selection: $selectedPickerOption) {
                                Text("Client").tag("Client")
                                Text("Expert").tag("Expert")
                            }
                            .pickerStyle(SegmentedPickerStyle())
                            .padding(.horizontal)
                        }
                    }
                    .padding(.top, 10)

                    Spacer()
                }

                // Bottom Navigation Bar
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button(action: { navigateToMessages = true }) {
                            Text("Messages")
                                .foregroundColor(.white)
                                .padding()
                        }
                        Spacer()
                        Button(action: {}) {
                            Circle()
                                .fill(Theme.accentColor)
                                .frame(width: 60, height: 60)
                                .overlay(Image(systemName: "plus")
                                    .font(.system(size: 24))
                                    .foregroundColor(.white))
                        }
                        Spacer()
                        Button(action: {}) {
                            Text("Settings")
                                .foregroundColor(.white)
                                .padding()
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
                }
            }
        }
    }
}

#Preview {
    Homepage()
}

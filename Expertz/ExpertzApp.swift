//
//  ExpertzApp.swift
//  Expertz
//
//  Created by Alan Huynh on 2024-10-12.
//

import SwiftUI
import Firebase

@main
struct ExpertzApp: App {
    // Register AppDelegate for handling lifecycle events
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    // Initialize Firebase
    init() {
        FirebaseApp.configure()
        print("FirebaseApp configured in ExpertzApp")
    }
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView()
            }
        }
    }
}

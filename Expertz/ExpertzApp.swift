//
//  ExpertzApp.swift
//  Expertz
//
//  Created by Alan Huynh on 2024-10-12.
//

import SwiftUI

@main
struct ExpertzApp: App {
    // Register AppDelegate for handling lifecycle events
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView()
            }
        }
    }
}

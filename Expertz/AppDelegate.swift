//
//  AppDelegate.swift
//  Expertz
//
//  Created by Ryan Loi on 2024-11-28.
//


import Firebase
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore
import UIKit


class AppDelegate: NSObject, UIApplicationDelegate {

    var window: UIWindow?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        // Configure Firebase
        FirebaseApp.configure()
        print("Firebase has been configured successfully.") // Optional logging
        return true
    }

    // Add other AppDelegate methods as needed
}

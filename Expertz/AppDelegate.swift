//
//  AppDelegate.swift
//  Expertz
//
//  Created by Ryan Loi on 2024-11-28.
// Credit: https://www.youtube.com/watch?v=vZEUAIHrsg8&t=482s


import Firebase
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore
import GoogleSignIn
import UIKit


class AppDelegate: NSObject, UIApplicationDelegate {

    var window: UIWindow?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        // Configure Firebase
//        FirebaseApp.configure()
        print("Firebase has been configured successfully.") // Optional logging
        return true
    }

    func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
           return GIDSignIn.sharedInstance.handle(url)
       }
}

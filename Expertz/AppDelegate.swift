//
//  AppDelegate.swift
//  Expertz
//
//  Created by Ryan Loi on 2024-11-28.
//  Credit: https://www.youtube.com/watch?v=vZEUAIHrsg8&t=482s


import Firebase
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore
import GoogleSignIn
import UIKit

// The AppDelegate class handles app-level events and configurations.
class AppDelegate: NSObject, UIApplicationDelegate {

    var window: UIWindow?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        return true
    }
    
    // Handles URLs opened by the app, we are using this to open the google sign in link
    func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
           return GIDSignIn.sharedInstance.handle(url)
       }
}

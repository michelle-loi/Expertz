//
//  GoogleSignInLogic.swift
//  Expertz
//
//  Created by Ryan Loi on 2024-11-28.
//


import SwiftUI
import Firebase
import FirebaseAuth
import GoogleSignIn

// Class for handling Google Sign-In logic
class GoogleSignInLogic: ObservableObject {
    // Published property to track login success status
    @Published var isLoginSuccessed = false

    // Function to begin Google Sign-In process
    func signInWithGoogle(completion: @escaping (Bool) -> Void) {
        // Retrieve the client ID from Firebase configuration
        guard let clientID = FirebaseApp.app()?.options.clientID else {
            completion(false)
            return
        }

        // Configure Google Sign-In with the retrieved client ID
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config

        // Start the Google Sign-In process
        GIDSignIn.sharedInstance.signIn(withPresenting: Application_utility.rootViewController) { user, error in
            if let error = error {
                print(error.localizedDescription)
                completion(false)
                return
            }

            // Extract user and ID token from the sign-in response
            guard let user = user?.user, let idToken = user.idToken else {
                completion(false)
                return
            }

            // Extract access token for Firebase credential creation
            let accessToken = user.accessToken
            let credential = GoogleAuthProvider.credential(withIDToken: idToken.tokenString, accessToken: accessToken.tokenString)

            // Use the credential to authenticate with Firebase
            Auth.auth().signIn(with: credential) { res, error in
                if let error = error {
                    print(error.localizedDescription)
                    completion(false)
                    return
                }
                
                // Ensure user is successfully signed in
                guard res?.user != nil else {
                    completion(false)
                    return
                }

                print("Google Sign-In successful")
                completion(true)
            }
        }
    }


    // Function to log out the current user
      func logout() async throws{
          // google logout
          GIDSignIn.sharedInstance.signOut()
          // firebase log out
          try Auth.auth().signOut()
      }
    
    
}









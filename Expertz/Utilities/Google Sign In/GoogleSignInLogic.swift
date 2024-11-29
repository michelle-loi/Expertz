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

class GoogleSignInLogic: ObservableObject {
    @Published var isLoginSuccessed = false

    func signInWithGoogle(completion: @escaping (Bool) -> Void) {
        guard let clientID = FirebaseApp.app()?.options.clientID else {
            completion(false)
            return
        }

        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config

        GIDSignIn.sharedInstance.signIn(withPresenting: Application_utility.rootViewController) { user, error in
            if let error = error {
                print(error.localizedDescription)
                completion(false)
                return
            }

            guard let user = user?.user, let idToken = user.idToken else {
                completion(false)
                return
            }

            let accessToken = user.accessToken
            let credential = GoogleAuthProvider.credential(withIDToken: idToken.tokenString, accessToken: accessToken.tokenString)

            Auth.auth().signIn(with: credential) { res, error in
                if let error = error {
                    print(error.localizedDescription)
                    completion(false)
                    return
                }
                guard res?.user != nil else {
                    completion(false)
                    return
                }

                print("Google Sign-In successful")
                completion(true)
            }
        }
    }


      
      func logout() async throws{
          GIDSignIn.sharedInstance.signOut()
          try Auth.auth().signOut()
      }
    
    
}









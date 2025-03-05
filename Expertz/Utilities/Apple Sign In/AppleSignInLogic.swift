// AppleSignInLogic.swift
// Expertz
//
// Created by Ryan Loi on 2024-03-03.

import Foundation
import AuthenticationServices
import Firebase
import FirebaseAuth

// Apple Sign-In logic class
class AppleSignInLogic: NSObject, ObservableObject {
    
    // variable track login success status
    @Published var isLoginSuccessed = false
    
    var completion: ((Bool) -> Void)?

    // Function to for Apple Sign-In process
    func signInWithApple(completion: @escaping (Bool) -> Void) {
        self.completion = completion
        
        let request = ASAuthorizationAppleIDProvider().createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.presentationContextProvider = self
        controller.performRequests()
    }
}

extension AppleSignInLogic: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {

    // Handle successful Apple sign-in
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            
            // Get the Apple ID token
            guard let idToken = appleIDCredential.identityToken else {
                print("Apple Sign-In failed: Identity token is nil.")
                self.completion?(false) // Token not found, return false
                return
            }
            
            let tokenString = String(data: idToken, encoding: .utf8)!
            
            // Create Firebase credentials using the Apple ID token
            let credential = OAuthProvider.credential(withProviderID: "apple.com", idToken: tokenString, accessToken: "")
            
            // Sign in with Firebase using the credential
            Auth.auth().signIn(with: credential) { (result, error) in
                if let error = error {
                    print("Error signing in with Apple: \(error.localizedDescription)")
                    self.completion?(false)
                    return
                }
                
                // Successfully signed in with Apple
                print("Apple Sign-In successful")
                self.completion?(true)
            }
        }
    }
    
    // Handle error cases during Apple sign-in
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("Apple Sign-In failed: \(error.localizedDescription)")
        self.completion?(false)
    }
    

    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return UIApplication.shared.windows.first { $0.isKeyWindow }!
    }
}

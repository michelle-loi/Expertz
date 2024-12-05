//
//  Application.swift
//  Expertz
//
//  Created by Ryan Loi on 2024-11-28.
//

import SwiftUI
import UIKit

// A utility class for accessing the root view controller of the application.
final class Application_utility{
    // Retrieves the root view controller of the current active scene.
    static var rootViewController: UIViewController{
        guard let screen = UIApplication.shared.connectedScenes.first as? UIWindowScene else{
            return .init()
            
        }
        
        // Attempt to get the root view controller from the first window of the scene.
        guard let root = screen.windows.first?.rootViewController else {
            return .init()
        }
        
        // Return the root view controller if found.
        return root
    }
    
    
}

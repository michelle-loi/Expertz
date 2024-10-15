//
//  ContentView.swift
//  Expertz
//
//  Created by Alan Huynh on 2024-10-12.
//

import SwiftUI

struct ContentView: View {
    @State var isLoggedIn:Bool = false
    
    var body: some View {
        // Check if user is logged in, if not go to Intro page
        NavigationStack{
            if isLoggedIn {
                Homepage()
            } else {
                Introduction()
            }
        }
    }
}

#Preview {
    ContentView()
}

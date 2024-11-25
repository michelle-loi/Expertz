//
//  Introduction.swift
//  Expertz
//
//  Created by Alan Huynh on 2024-10-13.
//

import SwiftUI

struct Introduction: View {
    // Navigation Flag to Sign Up Page
    @State private var navigateToSignUpPage = false

    var body: some View {
        // ZStack for background gradient
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [.cyan, .green]),
                startPoint: .top,
                endPoint: .bottom
            )
            // ignores safe border edges
            .ignoresSafeArea()
            
            // Earth Background - Positioned above the gradient, behind other elements
            Image("Earth_Background")
                .resizable()
                .scaledToFit()
                .frame(width: 700, height: 700)
                .offset(y: 100)
                .mask(
                    LinearGradient(
                        gradient: Gradient(stops: [
                            .init(color: .black.opacity(1.0), location: 0.0),
                            .init(color: .black.opacity(0.0), location: 1.0)
                        ]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )

            VStack {
                // Expertz Logo
                Image("Expertz_Logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50, height: 50)

                // Main Title Text
                Text("Expertz")
                    .font(Theme.titleFont)
                    .foregroundStyle(Theme.primaryColor)
                    .padding(.bottom, 20)

                // ZStack for the Headshots - placed on top of the Earth background
                ZStack {
                    Image("Headshot1")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 50)
                        .offset(x: -50, y: -80)

                    Image("Headshot2")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 50)
                        .offset(x: 100, y: -70)

                    Image("Headshot3")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 50)
                        .offset(x: -140, y: -30)

                    Image("Headshot4")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 50)
                        .offset(x: 30, y: -30)
                }
                .frame(maxWidth: .infinity, maxHeight: 300)

                Text("Bringing expertise to your doorstep!")
                    .font(Theme.titleFont)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 200)
                    .padding(.bottom, 30)

                // Navigation Button to Sign Up page
                Button(action: {
                    navigateToSignUpPage = true
                }) {
                    Text("Get started!")
                        .font(.headline)
                        .padding(20)
                        .frame(maxWidth: .infinity)
                        .background(
                            LinearGradient(
                                gradient: Gradient(colors: [Color.cyan, Color.green]),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .foregroundColor(.white)
                        .cornerRadius(100)
                        .overlay(
                            RoundedRectangle(cornerRadius: 100)
                                .stroke(Theme.primaryColor, lineWidth: 2)                         )
                }
                .padding(.horizontal, 175)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .padding(.top, 50)
        }
        .navigationDestination(isPresented: $navigateToSignUpPage) {
            SignUp()
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    Introduction()
}

import SwiftUI
import FirebaseAuth

struct Introduction: View {
    // Navigation flags
    @State private var navigateToSignUpPage = false
    @State private var navigateToHomepage = false

    var body: some View {
        ZStack {
            // 1) Earth background at the back
            Image("Earth_Background")
                .resizable()
                .scaledToFit()
                .frame(width: 700, height: 700)
                .offset(y: 100)
            
            // 2) Glass blur + teal gradient overlay
            Color.clear
                .background(.ultraThinMaterial)
                .overlay(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color(red: 0.00, green: 0.75, blue: 0.70),
                            Color(red: 0.00, green: 0.60, blue: 0.65)
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                    .opacity(0.3)
                )
                .ignoresSafeArea()

            // 3) Main content
            VStack {
                // --- Top Section ---
                VStack(spacing: 10) {
                    // Logo
                    Image("Expertz_Logo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                    
                    // "Expertz" text - Bold & White
                    Text("Expertz")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .shadow(color: Theme.primaryColor, radius: 0.4)
                        .shadow(color: Theme.primaryColor, radius: 0.4)
                        .shadow(color: Theme.primaryColor, radius: 0.4)
                }
                .frame(maxWidth: .infinity, alignment: .top)
                .padding(.top, 50)
                
                Spacer()

                // --- Bottom Section ---
                VStack(spacing: 20) {
                    // Tagline - Bold & White
                    Text("Bringing expertise to your doorstep!")
                                        .font(Theme.titleFont)
                                        .foregroundColor(.white)
                                        .multilineTextAlignment(.center)
                                        .padding(.horizontal, 200)
                                        .padding(.bottom, 30)
                                        .shadow(color: Theme.primaryColor, radius: 0.4)
                                        .shadow(color: Theme.primaryColor, radius: 0.4)
                                        .shadow(color: Theme.primaryColor, radius: 0.4)
                    // "Get started!" button
                    Button(action: {
                                        navigateToSignUpPage = true
                                    }) {
                                        Text("Get started!")
                                            .font(.headline)
                                            .fontWeight(.bold)
                                            .padding(20)
                                            .foregroundColor( Theme.primaryColor)
                                            .frame(maxWidth: .infinity)
                                            .background(.ultraThinMaterial)
                                            .foregroundColor(.white)
                                            .cornerRadius(100)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 100)
                                                    .stroke(Color(red: 0.00, green: 0.60, blue: 0.65), lineWidth: 2)
                                            )
                                    }
                                    .padding(.horizontal, 175)
                }
                .padding(.bottom, 50)
            }
        }
        .onAppear {
            if Auth.auth().currentUser != nil {
                print("User is logged in")
                navigateToHomepage = true
            }
        }
        .navigationDestination(isPresented: $navigateToHomepage) {
            Homepage()
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

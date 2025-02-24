import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct SignUpEmail: View {
    // Owns the shared data
    @StateObject private var signUpData = SignUpData()
    
    // Navigation triggers
    @State private var goToNextPage = false
    @State private var backPage = false
    
    var body: some View {
        ZStack(alignment: .top){
            Color.clear
                .background(.ultraThinMaterial)
                .overlay(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color(red: 0.00, green: 0.90, blue: 0.90),
                            Color(red: 0.00, green: 0.90, blue: 0.90)
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                    .opacity(0.3)
                )
                .ignoresSafeArea()
            VStack(spacing: 16) {
                Text("Create an account")
                    .font(Theme.titleFont)
                    .fontWeight(.bold)
                    .foregroundStyle(Theme.primaryColor)
                    .padding(.bottom, 100)
                    .padding(.top, 100)
                
                
                
                TextField("Email Address", text: $signUpData.emailAddress)
                    .customFormInputField()
                
                SecureField("Password", text: $signUpData.password)
                    .customFormInputField()
                
                SecureField("Re Enter Password", text: $signUpData.rePassword)
                    .customFormInputField()
                
                Spacer()
                
                // Next & Back Buttons
                VStack {
                    Button(action: {
                        // If you want to go back to an Intro view in a NavigationStack,
                        // set backPage = true. Otherwise, you can remove this button or dismiss().
                        backPage = true
                    }) {
                        Text("Back")
                    }
                    .customAlternativeDesignButton()
                    
                    Button(action: {
                        goToNextPage = true
                    }) {
                        Text("Next")
                    }
                    .customCTADesignButton()
                }
            }
            .padding()}
            // Navigation to next page
            .navigationDestination(isPresented: $goToNextPage) {
                SignUpNameGender(signUpData: signUpData)
            }
            // Navigation if you want to go back to some Introduction
            .navigationDestination(isPresented: $backPage) {
                SignUp()
            }
            .navigationBarBackButtonHidden(true)
        }
}
#Preview {
    SignUpEmail()
}

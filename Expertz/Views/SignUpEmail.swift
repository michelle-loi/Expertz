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
        VStack(alignment: .leading, spacing: 16) {
            Text("Let's get started!")
                .font(Theme.titleFont)
                .foregroundStyle(Theme.primaryColor)
                .padding(.top, 10)
            
            Text("Create an account")
                .font(Theme.inputFont)
                .foregroundStyle(Theme.primaryColor)
                .padding(.bottom, 10)
            
            TextField("Email Address", text: $signUpData.emailAddress)
                .customFormInputField()
            
            SecureField("Password", text: $signUpData.password)
                .customFormInputField()
            
            SecureField("Re Enter Password", text: $signUpData.rePassword)
                .customFormInputField()
            
            Spacer()
            
            // Next & Back Buttons
            HStack {
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
        .padding()
        // Navigation to next page
        .navigationDestination(isPresented: $goToNextPage) {
            SignUpNameGender(signUpData: signUpData)
        }
        // Navigation if you want to go back to some Introduction
        .navigationDestination(isPresented: $backPage) {
            Introduction()
        }
        .navigationBarBackButtonHidden(true)
    }
}
#Preview {
    SignUpEmail()
}

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct SignUpCountryAddress: View {
    @ObservedObject var signUpData: SignUpData
    
    @State private var goToNextPage = false
    @Environment(\.dismiss) private var dismiss
    
    let countries = ["United States", "Canada", "United Kingdom", "Australia", "Japan"]
    
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
                // Country Dropdown
                HStack {
                    Text("Country")
                        .font(.headline)
                    Picker("Select a Country", selection: $signUpData.selectedCountry) {
                        ForEach(countries, id: \.self) { country in
                            Text(country).tag(country)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                }
                
                TextField("Address", text: $signUpData.address)
                    .customFormInputField()
                
                Spacer()
                
                VStack {
                    Button(action: {
                        dismiss()
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
        .navigationDestination(isPresented: $goToNextPage) {
            SignUpExpertise(signUpData: signUpData)
        }
        .navigationBarBackButtonHidden(true)
    }
}
#Preview {
    SignUpCountryAddress(signUpData: SignUpData())
}

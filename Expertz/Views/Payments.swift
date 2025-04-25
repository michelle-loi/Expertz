import SwiftUI

struct PaymentView: View {
    let negotiatedPrice: Double
    var onPaymentSuccess: (() -> Void)? = nil
    
    @State private var cardHolderName: String = ""
    @State private var cardNumber: String = ""
    @State private var expiryDate: String = ""
    @State private var cvv: String = ""
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Payment")
                .font(.title)
                .padding(.top)
            
            Text("Amount: $\(negotiatedPrice, specifier: "%.2f")")
                .font(.headline)
            
            TextField("Card Holder Name", text: $cardHolderName)
                .customFormInputField()
            
            TextField("Card Number", text: $cardNumber)
                .keyboardType(.numberPad)
                .customFormInputField()
            
            HStack {
                TextField("Expiry (MM/YY)", text: $expiryDate)
                    .customFormInputField()
                TextField("CVV", text: $cvv)
                    .keyboardType(.numberPad)
                    .customFormInputField()
            }
            
            Button("Send Payment") {
                onPaymentSuccess?()
                presentationMode.wrappedValue.dismiss()
            }
            .padding()
            .background(Theme.primaryColor)
            .foregroundColor(.white)
            .cornerRadius(30)
            
            Spacer()
        }
        .padding()
    }
}

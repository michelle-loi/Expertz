//
//  Messages.swift
//  Expertz
//
//  Created by Ameriza on 2024-11-18.
//

import SwiftUI

struct Messages: View {
    var body: some View {
        VStack(spacing: 10) {
            ForEach(0..<5) { index in
                VStack(alignment: .leading) {
                    // Sender's name
                    Text("Sender Name \(index + 1)")
                        .font(.headline)
                        .foregroundColor(Theme.primaryColor)

                    // Message preview
                    Text("This is a preview of the message body...")
                        .font(.subheadline)
                        .foregroundColor(.black)
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Theme.accentColor)
                .cornerRadius(15)
                .shadow(radius: 3)
                .padding(.horizontal)
            }
            Spacer()
        }
        .navigationTitle("Messages")
        .background(Theme.secondaryColor.ignoresSafeArea())
    }
}

#Preview {
    Messages()
}

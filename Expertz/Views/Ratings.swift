import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct RatingView: View {
    var recipientName: String
    var fromUserId: String
    var onRatingSubmitted: (() -> Void)? = nil
    
    @State private var rating: Double = 3.0
    @State private var review: String = ""
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Leave a Rating")
                .font(.title)
                .padding(.top)
                .foregroundColor(Theme.primaryColor)

            HStack {
                Text("Rating: \(Int(rating))/5")
                Slider(value: $rating, in: 1...5, step: 1)
                    .tint(Theme.primaryColor)
            }
            .padding()
            
            TextField("Give a brief description", text: $review)
                .padding()
                .font(Theme.inputFont.bold())
                .frame(maxWidth: .infinity)
                .background(.ultraThinMaterial)
                .foregroundColor(Theme.primaryColor)
                .cornerRadius(30)
                .overlay(
                    RoundedRectangle(cornerRadius: 30)
                        .stroke(Theme.primaryColor, lineWidth: 2)
                )
            
            Button("Submit Rating") {
                submitRating()
            }
            .padding()
            .background(Theme.primaryColor)
            .foregroundColor(.white)
            .cornerRadius(30)
            
            Spacer()
        }
        .padding()
    }
    
    private func submitRating() {
        let db = Firestore.firestore()
        let data: [String: Any] = [
            "toUserName": recipientName,
            "fromUserId": fromUserId,
            "rating": rating,
            "review": review,
            "timestamp": Date()
        ]
        db.collection("Ratings").addDocument(data: data) { error in
            if let error = error {
                print("Error submitting rating: \(error.localizedDescription)")
            } else {
                onRatingSubmitted?()
            }
        }
    }
}


import SwiftUI

struct JobEntry: Identifiable {
    let id = UUID()
    var name: String
    var description: String
    var payment: Int
}

let jobEntries = [
    JobEntry(name: "John Kline", description: "Repaired transmission", payment: 350),
    JobEntry(name: "Sarah Lee", description: "Fixed a leaking pipe under the kitchen sink", payment: 200),
    JobEntry(name: "Mark Turner", description: "Replaced faulty wiring in the living room", payment: 250),
    JobEntry(name: "Emily Davis", description: "Built custom shelves in the bedroom", payment: 275),
    JobEntry(name: "David Chen", description: "Welded a broken steel beam in the garage", payment: 300),
    JobEntry(name: "Lena Garcia", description: "Replaced HVAC system filter and cleaned ducts", payment: 225),
    JobEntry(name: "Robert Jameson", description: "Painted the entire living room", payment: 150),
    JobEntry(name: "Brian Adams", description: "Changed the locks on all exterior doors", payment: 120),
    JobEntry(name: "Jessica Cooper", description: "Repaired roof leak above the kitchen", payment: 500),
    JobEntry(name: "James Williams", description: "Installed drywall in the basement", payment: 180),
    JobEntry(name: "Rachel Murphy", description: "Mowed lawn and trimmed hedges", payment: 220),
    JobEntry(name: "Michael Thompson", description: "Installed new brick walkway in the garden", payment: 400),
    JobEntry(name: "Kevin Harris", description: "Replaced a broken sewer line", payment: 375),
    JobEntry(name: "Olivia Wright", description: "Cleaned entire house after a move-out", payment: 100),
    JobEntry(name: "Joshua Parker", description: "Repaired washing machine drum", payment: 150),
    JobEntry(name: "Samantha Lopez", description: "Cleaned and maintained pool", payment: 140),
    JobEntry(name: "Jason Bell", description: "Painted the exterior of a two-story house", payment: 350),
    JobEntry(name: "Lauren Green", description: "Removed large tree in the front yard", payment: 500),
    JobEntry(name: "Andrew Miller", description: "Excavated the backyard for a new patio", payment: 700),
    JobEntry(name: "Megan Scott", description: "Pressure washed driveway and patio", payment: 180)
]

struct DashboardPayments: View {
    var body: some View {
        ScrollView {
            VStack {
                ForEach(jobEntries, id: \.id) { job in
                    PaymentCard(jobEntry: job)
                }
            }
            .padding()
        }
        .background(
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
        )
        .navigationTitle("Payment History")
    }
}

struct PaymentCard: View {
    var jobEntry: JobEntry

    var body: some View {
        GroupBox {
            GroupBox {
                HStack {
                    VStack(alignment: .leading) {
                        Text("+$\(jobEntry.payment)")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundStyle(.green)
                        Text(jobEntry.description)
                            .foregroundStyle(.gray)
                    }

                    Spacer()
                }
            }
        } label: {
            Label(jobEntry.name, systemImage: "creditcard")
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(Theme.primaryColor)
        }
    }
}


#Preview {
    DashboardPayments()
}

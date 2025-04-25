import SwiftUI
import Charts

struct Dashboard: View {
    var body: some View {
        ScrollView {
            VStack {
                RatingsView()
                RatingTrendView()
                EarningsView()
                JobStatusView()
            }
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
        .navigationTitle("Dashboard")
    }
}


// This displays the current user rating based on the reviews they got out of 5
struct RatingsView: View {
    
    let userRating = 4.86
    let maxRating = 5.0
    let numberReviews = 378
    
    let title = "Current User Rating"
    
    var body: some View {
        VStack {
            VStack(alignment: .leading) {
                // Card title
                Text(title)
                    .font(.title2.bold())
                    .padding([.leading, .top])
                
                // Subtitle
                Text("Based on \(numberReviews) reviews")
                    .font(.caption2)
                    .foregroundColor(.gray)
                    .padding(.leading)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            // This is the chart representing the users rating
            Chart {
                
                // This sector shows the users rating
                SectorMark(
                    angle: .value("Rating", userRating),
                    innerRadius: .ratio(0.6),
                    angularInset: 2
                )
                .cornerRadius(5)
                .foregroundStyle(Theme.primaryColor)
                
                // Compute how much rating the user didn't get
                SectorMark(
                    angle: .value("Remaining", maxRating - userRating)
                )
                .foregroundStyle(.clear) // don't show the missing ratings
            }
            .padding()
            .scaledToFit()
            .chartLegend(alignment: .center, spacing: 16)
            .frame(width: 200, height: 200)
            
            // This centers the rating in the middle of the circle
            .chartBackground { chartProxy in
                GeometryReader { geometry in
                    if let anchor = chartProxy.plotFrame {
                        let frame = geometry[anchor]
                        Text("\(userRating, specifier: "%.2f") / \(maxRating, specifier: "%.2f")")
                            .position(x: frame.midX, y: frame.midY)
                    }
                }
            }
        }
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Theme.primaryColor.opacity(0.8), radius: 2)
        .padding([.leading, .trailing])
    }
}


// This displays the number of ratings the users achieved each month for each category of rating
struct PositiveRating: Identifiable {
    let id = UUID()
    let month: String
    let number: Int
}

struct AverageRating: Identifiable {
    let id = UUID()
    let month: String
    let number: Int
}

struct NegativeRating: Identifiable {
    let id = UUID()
    let month: String
    let number: Int
}

struct RatingTrendView: View {
    
    let positiveRatings: [PositiveRating] = [
        PositiveRating(month: "Jan", number: 0),
        PositiveRating(month: "Feb", number: 2),
        PositiveRating(month: "Mar", number: 2),
        PositiveRating(month: "Apr", number: 4),
        PositiveRating(month: "May", number: 8),
        PositiveRating(month: "Jun", number: 15),
        PositiveRating(month: "Jul", number: 13),
        PositiveRating(month: "Aug", number: 16),
        PositiveRating(month: "Sep", number: 19),
        PositiveRating(month: "Oct", number: 20),
        PositiveRating(month: "Nov", number: 22),
        PositiveRating(month: "Dec", number: 25)
    ]
    
    let averageRatings: [AverageRating] = [
        AverageRating(month: "Jan", number: 3),
        AverageRating(month: "Feb", number: 2),
        AverageRating(month: "Mar", number: 2),
        AverageRating(month: "Apr", number: 0),
        AverageRating(month: "May", number: 2),
        AverageRating(month: "Jun", number: 0),
        AverageRating(month: "Jul", number: 0),
        AverageRating(month: "Aug", number: 1),
        AverageRating(month: "Sep", number: 0),
        AverageRating(month: "Oct", number: 0),
        AverageRating(month: "Nov", number: 1),
        AverageRating(month: "Dec", number: 0)
    ]

    let negativeRatings: [NegativeRating] = [
        NegativeRating(month: "Jan", number: 0),
        NegativeRating(month: "Feb", number: 0),
        NegativeRating(month: "Mar", number: 1),
        NegativeRating(month: "Apr", number: 0),
        NegativeRating(month: "May", number: 2),
        NegativeRating(month: "Jun", number: 0),
        NegativeRating(month: "Jul", number: 0),
        NegativeRating(month: "Aug", number: 1),
        NegativeRating(month: "Sep", number: 0),
        NegativeRating(month: "Oct", number: 0),
        NegativeRating(month: "Nov", number: 0),
        NegativeRating(month: "Dec", number: 1)
    ]
    
    var body: some View {
        let title = "Yearly Rating Trend"
        let info = "Tracks the different types of reviews you got each month"
        
        VStack(alignment: .leading) {
            
            // Card title
            Text(title)
                .font(.title2.bold())
                .padding([.leading, .top])
            
            // Subtitle
            Text(info)
                .font(.caption2)
                .foregroundColor(.gray)
                .padding(.leading)

            // This is the line graph
            Chart {
                ForEach(positiveRatings) { rating in
                    LineMark(
                        x: .value("Month", rating.month),
                        y: .value("Reviews", rating.number)
                    )
                    .foregroundStyle(by: .value("Positive", "Positive"))
                    .interpolationMethod(.catmullRom)
                    .symbol(.circle)
                }
                
                ForEach(averageRatings) { rating in
                    LineMark(
                        x: .value("Month", rating.month),
                        y: .value("Reviews", rating.number)
                    )
                    .foregroundStyle(by: .value("Average", "Average"))
                    .interpolationMethod(.catmullRom)
                    .symbol(.circle)
                }
                
                ForEach(negativeRatings) { rating in
                    LineMark(
                        x: .value("Month", rating.month),
                        y: .value("Reviews", rating.number)
                    )
                    .foregroundStyle(by: .value("Negative", "Negative"))
                    .interpolationMethod(.catmullRom)
                    .symbol(.circle)
                }
            }
            .padding([.leading, .trailing, .bottom])
            .frame(height: 300)
        }
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Theme.primaryColor.opacity(0.8), radius: 2)
        .padding([.leading, .trailing])
    }
}

// This displays the users earnings for the week
struct Earnings: Identifiable {
    let id = UUID()
    let day: String
    let amount: Double
}

struct EarningsView: View {
    let earnings: [Earnings] = [
        Earnings(day: "SUN", amount: 160.0),
        Earnings(day: "MON", amount: 120.0),
        Earnings(day: "TUE", amount: 200.5),
        Earnings(day: "WED", amount: 150.0),
        Earnings(day: "THUR", amount: 180.75),
        Earnings(day: "FRI", amount: 220.0),
        Earnings(day: "SAT", amount: 90.25)
    ]
    
    let title = "Earnings This Week"
    let subtitle = "Last 7 Days"
    let total = "$1121.50"
    
    var body: some View {
        VStack {
            VStack(alignment: .leading) {
                HStack {
                    // Card title
                    Text(title)
                        .font(.title2.bold())
                        .padding([.top, .leading])

                    Spacer()
                    
                    // Could link to a page that lists all the users payments
                    NavigationLink(destination: DashboardPayments()) {
                        Image(systemName: "arrow.right.circle.fill")
                            .font(.title)
                            .padding([.top, .trailing])
                            .foregroundColor(Theme.primaryColor)
                    }
                }
                
                // Subtitle
                Text(subtitle)
                    .font(.caption2)
                    .foregroundColor(.gray)
                    .padding(.leading)
                
                Text(total)
                    .font(.title)
                    .padding()

                // This is the bar chart for the users earnings in a week
                Chart(earnings) { item in
                    BarMark(
                        x: .value("Day", item.day),
                        y: .value("Earnings", item.amount)
                    )
                    .foregroundStyle(Theme.primaryColor)
                }
                .frame(height: 200)
                .padding([.leading, .trailing, .bottom])
            }
            .frame(maxWidth: .infinity)
        }
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Theme.primaryColor.opacity(0.8), radius: 2)
        .padding([.leading, .trailing])
    }
}


struct JobStatus: Identifiable {
    let id = UUID()
    let status: String
    let count: Int
}

struct JobStatusView: View {
    let statuses: [JobStatus] = [
        JobStatus(status: "Completed", count: 756),
        JobStatus(status: "Pending", count: 20)
    ]
    
    let title = "Jobs"
    
    var body: some View {
        VStack(alignment: .leading) {
            
            HStack {
                Text(title)
                    .font(.title2.bold())
                    .padding([.top, .leading])
                Spacer()
                
                // Could link to a page that lists all the users completed and current jobs
                NavigationLink(destination: DashboardJobs()) {
                    Image(systemName: "arrow.right.circle.fill")
                        .font(.title)
                        .padding([.top, .trailing])
                        .foregroundColor(Theme.primaryColor)
                }
            }

            
            HStack(alignment: .center, spacing: 10) {
                Chart(statuses) { item in
                    SectorMark (
                        angle: .value("Count", item.count),
                        innerRadius: .ratio(0.6),
                        angularInset: 2
                    )
                    .cornerRadius(5)
                    .foregroundStyle(by: .value("Status", item.status))
                }
                .scaledToFit()
                .chartLegend(alignment: .center, spacing: 16)
                .frame(width: 200, height: 200)
                
                VStack(alignment: .leading) {
                    ForEach(statuses, id: \.status) { item in
                        Text("\(item.status): \(item.count)")
                            .font(.headline)
                            .foregroundColor(.primary)
                    }
                    
                    let totalCount = statuses.reduce(0) { $0 + $1.count }
                    
                    Text("Total: \(totalCount)")
                        .font(.headline)
                        .foregroundColor(.primary)
                }
            }
            .frame(maxWidth: .infinity)
            .padding()
        }
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Theme.primaryColor.opacity(0.8), radius: 2)
        .padding([.leading, .trailing])
    }
}


#Preview {
    Dashboard()
}

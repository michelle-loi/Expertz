//
//  DashboardJobs.swift
//  Expertz
//
//  Created by Michelle Loi on 2025-04-05.
//

import SwiftUI

struct DashboardJobs: View {
    var body: some View {
        ScrollView {
            VStack {
                NavigationLink(destination: ViewRequests()) {
                    HStack {
                        Spacer()
                        Text("Go to pending jobs")
                            .foregroundColor(Theme.primaryColor)
                        Image(systemName: "arrow.right.circle.fill")
                            .foregroundColor(Theme.primaryColor)
                    }
                    .padding(.vertical, 8)
                }
                
                ForEach(jobEntries, id: \.id) { job in
                    JobCard(jobEntry: job)
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
        .navigationTitle("Job History")
    }
}

struct JobCard: View {
    var jobEntry: JobEntry

    var body: some View {
        GroupBox {
            HStack {
                VStack(alignment: .leading) {
                    Text("$\(jobEntry.payment)")
                        .foregroundStyle(.gray)
                    Text(jobEntry.description)
                        .foregroundStyle(.gray)
                }

                Spacer()
            }
        
        } label: {
            Label(jobEntry.name, systemImage: "person.circle")
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(Theme.primaryColor)
        }
    }
}

#Preview {
    DashboardJobs()
}

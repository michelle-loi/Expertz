//  - Nested View Component for Homepage View
//  - Bottom Navigation View Component
//  - Functionality is to navigate to other view pages
// 

import SwiftUI

struct BottomNavigationBar: View {
    @Binding var navigateToMessages: Bool
    @Binding var navigateToSettings: Bool
    @Binding var navigateToProfile: Bool
    @Binding var navigateToRequests: Bool
    @Binding var showPostJobView: Bool

    var body: some View {
        HStack {
            Spacer()
            Button(action: { navigateToMessages = true }) {
                VStack {
                    Image(systemName: "bubble.left.and.bubble.right")
                        .foregroundColor(Theme.primaryColor)
                    Text("Messages")
                        .foregroundStyle(Theme.primaryColor)
                }
            }
            Button(action: { navigateToRequests = true }) {
                VStack {
                    Image(systemName: "person.crop.circle.badge.exclamationmark")
                        .foregroundColor(Theme.primaryColor)
                    Text("Requests")
                        .foregroundStyle(Theme.primaryColor)
                }
            }
            Button(action: { showPostJobView.toggle() }) {
                Circle()
                    .fill(Theme.primaryColor)
                    .frame(width: 45, height: 45)
                    .overlay(Image(systemName: "plus")
                        .font(.system(size: 24))
                        .foregroundColor(.white))
            }
            Button(action: { navigateToSettings = true }) {
                VStack {
                    Image(systemName: "gear")
                        .foregroundColor(Theme.primaryColor)
                    Text("Settings")
                        .foregroundStyle(Theme.primaryColor)
                }
            }
            Button(action: { navigateToProfile = true }) {
                VStack {
                    Image(systemName: "person")
                        .foregroundColor(Theme.primaryColor)
                    Text("Profile")
                        .foregroundStyle(Theme.primaryColor)
                }
            }
            Spacer()
        }
        .frame(height: 70)
        .background(.ultraThinMaterial)
        .cornerRadius(30)
        .shadow(radius: 5)
        .overlay(
            RoundedRectangle(cornerRadius: 100)
                .stroke(Theme.primaryColor, lineWidth: 2)
        )
        .padding(.horizontal, 20)
    }
}
#Preview {
    Homepage()
}

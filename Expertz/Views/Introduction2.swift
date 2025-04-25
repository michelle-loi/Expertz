import SwiftUI
import FirebaseAuth

struct Introduction2: View {
    @State private var navigateToSignUpPage = false
    @State private var navigateToHomepage = false
    @State private var currentPage = 0

    let images = ["Expert_Search", "Expert_Profile", "Expert_Post", "Expert_Request", "Expert_Message"]
    let descriptions = [
        "Join a global community of over 100,000 experts and clients, right at your fingertips.",
        "Easily search for expert services or client requests.",
        "Quickly post your own service requests or expert offerings.",
        "Manage all your active requests with ease, whether from clients or to experts.",
        "Instantly connect and chat with clients and experts."
    ]

    var body: some View {
        ZStack {
            Image("Earth_Background")
                .resizable()
                .scaledToFit()
                .frame(width: 700, height: 700)
                .offset(y: 100)

            Color.clear
                .background(.ultraThinMaterial)
                .overlay(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color(red: 0.00, green: 0.75, blue: 0.70),
                            Color(red: 0.00, green: 0.60, blue: 0.65)
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                    .opacity(0.3)
                )
                .ignoresSafeArea()

            VStack {
                // Carousel images
                TabView(selection: $currentPage) {
                    ForEach(0..<images.count, id: \.self) { index in
                        VStack {
                            Image(images[index])
                                .resizable()
                                .scaledToFit()
                                .frame(height: 580)
                                .padding(.horizontal, 30)
                                .padding(.bottom, 10)
                                .shadow(color: Theme.primaryColor, radius: 0.4)

                            // Description under image
                            Text(descriptions[index])
                                .font(.title2)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)
                                .fixedSize(horizontal: false, vertical: true)
                                .frame(maxWidth: 350)
                                .padding(.horizontal)
                        }
                        .tag(index)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .frame(height: 750)
                .animation(.easeInOut, value: currentPage)
                .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .never))

                HStack(spacing: 8) {
                    ForEach(0..<images.count, id: \.self) { index in
                        Circle()
                            .fill(index == currentPage ? Color.white : Color.white.opacity(0.5))
                            .frame(width: 8, height: 8)
                            .animation(.easeInOut(duration: 0.3), value: currentPage)
                    }
                }
                .padding(.bottom, 20)

                Spacer()

                Button(action: {
                    if currentPage < images.count - 1 {
                        withAnimation {
                            currentPage += 1
                        }
                    } else {
                        navigateToSignUpPage = true
                    }
                }) {
                    Text(currentPage == images.count - 1 ? "Get Started!" : "Next")
                        .font(.headline)
                        .fontWeight(.bold)
                        .padding(20)
                        .foregroundColor(Theme.primaryColor)
                        .frame(maxWidth: .infinity)
                        .background(.ultraThinMaterial)
                        .cornerRadius(100)
                        .overlay(
                            RoundedRectangle(cornerRadius: 100)
                                .stroke(Color(red: 0.00, green: 0.60, blue: 0.65), lineWidth: 2)
                        )
                }
                .padding(.horizontal, 175)
                .padding(.bottom, 50)
            }
        }
        .onAppear {
            if Auth.auth().currentUser != nil {
                navigateToHomepage = true
            }
        }
        .navigationDestination(isPresented: $navigateToHomepage) {
            Homepage()
        }
        .navigationDestination(isPresented: $navigateToSignUpPage) {
            SignUp()
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    Introduction2()
}

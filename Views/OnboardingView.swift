import SwiftUI

struct OnboardingView: View {
    
    @State private var currentPage = 0
    @State private var showLogin = false

    private let pages = [
        OnboardingPage(
            title: "Help Your Community",
            description: "Connect with people in need and those willing to help. Together, we can make a difference."
        ),
        OnboardingPage(
            title: "Small Actions Create Big Impact",
            description: "Whether it's a simple errand, donation, or a helping hand — your support matters."
        )
    ]
    
    var body: some View {
        ZStack {
            Color(
                red: 0.95,
                green: 0.98,
                blue: 0.97
            )
            .ignoresSafeArea()
            
            VStack(spacing: 0) {
                
                // Skip
                HStack {
                    Spacer()
                    
                    Button("Skip") {
                        showLogin = true
                    }
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(
                        Color(
                            red: 0.00,
                            green: 0.55,
                            blue: 0.45
                        )
                    )
                }
                .padding(.horizontal, 24)
                .padding(.top, 16)
                
                Spacer()
                
                // Illustration
                OnboardingIllustration(page: currentPage)
                    .frame(height: 170)
                    .padding(.horizontal, 35)
                
                // Title
                Text(pages[currentPage].title)
                    .font(.system(size: 21, weight: .bold))
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.black)
                    .padding(.horizontal, 30)
                    .padding(.top, 22)
                
                // Description
                Text(pages[currentPage].description)
                    .font(.system(size: 13))
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.gray)
                    .lineSpacing(4)
                    .padding(.horizontal, 45)
                    .padding(.top, 10)
                
                // Page indicators
                HStack(spacing: 5) {
                    ForEach(0..<pages.count, id: \.self) { index in
                        Capsule()
                            .fill(
                                index == currentPage
                                ? Color(
                                    red: 0.00,
                                    green: 0.55,
                                    blue: 0.45
                                )
                                : Color(
                                    red: 0.65,
                                    green: 0.82,
                                    blue: 0.78
                                )
                            )
                            .frame(
                                width: index == currentPage ? 14 : 5,
                                height: 5
                            )
                    }
                }
                .padding(.top, 20)
                
                Spacer()
                
                // Bottom button
                Button {
                    if currentPage < pages.count - 1 {
                        withAnimation {
                            currentPage += 1
                        }
                    } else {
                        showLogin = true
                    }
                } label: {
                    Text(
                        currentPage == 0
                        ? "Next"
                        : "Get Started"
                    )
                    .font(.system(size: 14, weight: .bold))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 48)
                    .background(
                        Color(
                            red: 0.00,
                            green: 0.55,
                            blue: 0.45
                        )
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                .padding(.horizontal, 24)
                
                // Footer
                Text("Bayanihan · Community Assistance Platform")
                    .font(.system(size: 9, weight: .medium))
                    .foregroundStyle(
                        Color(
                            red: 0.35,
                            green: 0.68,
                            blue: 0.62
                        )
                    )
                    .padding(.top, 8)
                    .padding(.bottom, 12)
            }
        }
        .statusBarHidden(false)
        .toolbar(.hidden, for: .navigationBar)
        .navigationDestination(isPresented: $showLogin) {
            LoginView()
        }
    }
}


// MARK: - Onboarding Data

struct OnboardingPage {
    let title: String
    let description: String
}


// MARK: - Illustration

struct OnboardingIllustration: View {
    
    let page: Int
    
    var body: some View {
        ZStack {
            
            // Ground
            RoundedRectangle(cornerRadius: 4)
                .fill(
                    Color(
                        red: 0.45,
                        green: 0.70,
                        blue: 0.66
                    )
                )
                .frame(height: 45)
                .padding(.horizontal, 10)
                .offset(y: 50)
            
            if page == 0 {
                
                // Houses
                HStack(spacing: 35) {
                    OnboardingHouse()
                    OnboardingHouse()
                }
                .offset(y: 35)
                
                // People
                HStack(spacing: -3) {
                    OnboardingPerson(
                        color: Color(
                            red: 0.25,
                            green: 0.78,
                            blue: 0.62
                        )
                    )
                    
                    OnboardingPerson(
                        color: Color(
                            red: 1.0,
                            green: 0.65,
                            blue: 0.25
                        )
                    )
                }
                .offset(y: -15)
                
                // Heart
                Image(systemName: "heart.fill")
                    .font(.system(size: 13))
                    .foregroundStyle(.pink.opacity(0.7))
                    .offset(y: -58)
                
            } else {
                
                // People helping
                HStack(spacing: 28) {
                    OnboardingPerson(
                        color: Color(
                            red: 0.25,
                            green: 0.78,
                            blue: 0.62
                        )
                    )
                    
                    OnboardingPerson(
                        color: Color(
                            red: 1.0,
                            green: 0.65,
                            blue: 0.25
                        )
                    )
                }
                .offset(y: -8)
                
                // Gift
                Image(systemName: "gift")
                    .font(.system(size: 32, weight: .medium))
                    .foregroundStyle(
                        Color(
                            red: 0.00,
                            green: 0.55,
                            blue: 0.45
                        )
                    )
                    .offset(y: 3)
                
                // Decorative hearts
                Image(systemName: "heart.fill")
                    .font(.system(size: 10))
                    .foregroundStyle(.pink.opacity(0.7))
                    .offset(x: -18, y: -52)
                
                Image(systemName: "heart.fill")
                    .font(.system(size: 8))
                    .foregroundStyle(.yellow.opacity(0.8))
                    .offset(x: 20, y: -48)
            }
        }
    }
}


// MARK: - Person

struct OnboardingPerson: View {
    
    let color: Color
    
    var body: some View {
        VStack(spacing: 2) {
            
            Circle()
                .fill(color)
                .frame(width: 25, height: 25)
            
            RoundedRectangle(cornerRadius: 7)
                .fill(color)
                .frame(width: 28, height: 35)
        }
    }
}


// MARK: - House

struct OnboardingHouse: View {
    
    var body: some View {
        VStack(spacing: 0) {
            
            Triangle()
                .fill(
                    Color(
                        red: 0.00,
                        green: 0.55,
                        blue: 0.45
                    )
                )
                .frame(width: 48, height: 30)
            
            RoundedRectangle(cornerRadius: 2)
                .fill(
                    Color(
                        red: 0.55,
                        green: 0.75,
                        blue: 0.72
                    )
                )
                .frame(width: 42, height: 35)
        }
    }
}


#Preview {
    OnboardingView()
}
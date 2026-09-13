import SwiftUI

struct SplashView: View {
    
    @State private var showOnboarding = false
    
    var body: some View {
        ZStack {
            // Background
            Color(
                red: 0.02,
                green: 0.55,
                blue: 0.45
            )
            .ignoresSafeArea()
            
            VStack {
                Spacer()
                
                // Bayanihan Logo
                VStack(spacing: 8) {
                    
                    ZStack {
                        Image(systemName: "heart.fill")
                            .font(.system(size: 25))
                            .foregroundStyle(.white)
                            .offset(y: -18)
                        
                        HStack(spacing: 3) {
                            RoundedRectangle(cornerRadius: 8)
                                .fill(.white.opacity(0.9))
                                .frame(width: 28, height: 18)
                                .rotationEffect(.degrees(-8))
                            
                            RoundedRectangle(cornerRadius: 8)
                                .fill(.white.opacity(0.9))
                                .frame(width: 28, height: 18)
                                .rotationEffect(.degrees(8))
                        }
                    }
                    .frame(height: 55)
                    
                    Text("Bayanihan")
                        .font(.system(size: 26, weight: .bold))
                        .foregroundStyle(.white)
                    
                    Text("Together We Can Make a Difference")
                        .font(.system(size: 11, weight: .medium))
                        .foregroundStyle(.white.opacity(0.9))
                }
                
                // Loading Dots
                HStack(spacing: 5) {
                    Capsule()
                        .fill(.white.opacity(0.45))
                        .frame(width: 14, height: 4)
                    
                    Circle()
                        .fill(.white.opacity(0.45))
                        .frame(width: 4, height: 4)
                    
                    Circle()
                        .fill(.white.opacity(0.45))
                        .frame(width: 4, height: 4)
                }
                .padding(.top, 25)
                
                Spacer()
                
                // Bottom Community Illustration
                CommunityIllustration()
                    .padding(.horizontal, 25)
                    .padding(.bottom, 12)
            }
        }
        .statusBarHidden(true)
        .toolbar(.hidden, for: .navigationBar)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                showOnboarding = true
            }
        }
        .navigationDestination(isPresented: $showOnboarding) {
            OnboardingView()
        }
    }
}


// MARK: - Community Illustration

struct CommunityIllustration: View {
    
    var body: some View {
        ZStack(alignment: .bottom) {
            
            // Ground
            RoundedRectangle(cornerRadius: 2)
                .fill(.white.opacity(0.08))
                .frame(height: 55)
            
            HStack(alignment: .bottom, spacing: 8) {
                
                // House 1
                SmallHouse()
                    .opacity(0.35)
                
                // People
                HStack(spacing: -3) {
                    Circle()
                        .fill(.white.opacity(0.45))
                        .frame(width: 13, height: 13)
                    
                    Circle()
                        .fill(.white.opacity(0.45))
                        .frame(width: 13, height: 13)
                }
                .padding(.bottom, 22)
                
                // House 2
                SmallHouse()
                    .opacity(0.45)
                
                // House 3
                SmallHouse()
                    .opacity(0.30)
                
                // House 4
                SmallHouse()
                    .opacity(0.40)
            }
        }
        .frame(height: 95)
    }
}


// MARK: - House

struct SmallHouse: View {
    
    var body: some View {
        VStack(spacing: 0) {
            
            // Roof
            Triangle()
                .fill(.white.opacity(0.35))
                .frame(width: 45, height: 25)
            
            // House body
            ZStack(alignment: .bottom) {
                
                Rectangle()
                    .fill(.white.opacity(0.25))
                    .frame(width: 38, height: 35)
                
                RoundedRectangle(cornerRadius: 2)
                    .fill(.white.opacity(0.4))
                    .frame(width: 10, height: 18)
                    .padding(.bottom, 2)
            }
        }
    }
}


// MARK: - Triangle Shape

struct Triangle: Shape {
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        path.move(
            to: CGPoint(
                x: rect.midX,
                y: rect.minY
            )
        )
        
        path.addLine(
            to: CGPoint(
                x: rect.maxX,
                y: rect.maxY
            )
        )
        
        path.addLine(
            to: CGPoint(
                x: rect.minX,
                y: rect.maxY
            )
        )
        
        path.closeSubpath()
        
        return path
    }
}


#Preview {
    NavigationStack {
        SplashView()
    }
}
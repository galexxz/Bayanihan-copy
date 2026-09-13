import SwiftUI

struct AppTabBarView: View {

    @State private var selectedTab: AppTab = .home
    @State private var showPostRequest = false

    var body: some View {

        ZStack(alignment: .bottom) {

            TabView(selection: $selectedTab) {

                // MARK: - Home

                HomeView()
                    .tabItem {
                        Label(
                            "Home",
                            systemImage: "house.fill"
                        )
                    }
                    .tag(AppTab.home)


                // MARK: - Requests

                RequestsView()
                    .tabItem {
                        Label(
                            "Requests",
                            systemImage: "hands.sparkles.fill"
                        )
                    }
                    .tag(AppTab.requests)


                // MARK: - Activity

                ActivityView()
                    .tabItem {
                        Label(
                            "Activity",
                            systemImage: "clock.arrow.circlepath"
                        )
                    }
                    .tag(AppTab.activity)


                // MARK: - Profile

                ProfileView()
                    .tabItem {
                        Label(
                            "Profile",
                            systemImage: "person.fill"
                        )
                    }
                    .tag(AppTab.profile)
            }
            .tint(
                Color(
                    red: 0.00,
                    green: 0.55,
                    blue: 0.45
                )
            )


            // MARK: - Post (Emphasized Center Action)

            Button {
                showPostRequest = true
            } label: {

                Image(
                    systemName: "plus"
                )
                .font(
                    .system(
                        size: 22,
                        weight: .bold
                    )
                )
                .foregroundStyle(.white)
                .frame(
                    width: 58,
                    height: 58
                )
                .background(
                    Color(
                        red: 0.00,
                        green: 0.55,
                        blue: 0.45
                    )
                )
                .clipShape(Circle())
                .shadow(
                    color: .black.opacity(0.25),
                    radius: 6,
                    y: 3
                )
            }
            .buttonStyle(.plain)
            .accessibilityLabel("Post")
            .offset(y: -18)
        }
        .toolbar(.hidden, for: .navigationBar)
        .navigationBarBackButtonHidden(true)
        .sheet(isPresented: $showPostRequest) {
            PostRequestView()
        }
    }
}


// MARK: - App Tab

enum AppTab: Hashable {

    case home
    case requests
    case activity
    case profile
}


// MARK: - Preview

#Preview {
    
    AppTabBarView()
        .environment(BayanihanController())
}
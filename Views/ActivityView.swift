import SwiftUI

struct ActivityView: View {
    
    @Environment(BayanihanController.self) private var controller
    
    private var myRequests: [CommunityRequest] {
        controller.requests.filter {
            $0.requesterUsername == controller.currentUser.username
        }
    }
    
    private var helpedRequests: [CommunityRequest] {
        controller.requests.filter {
            $0.helperName == controller.currentUser.name
        }
    }
    
    private var totalActivity: Int {
        myRequests.count + helpedRequests.count
    }
    
    var body: some View {
        
        NavigationStack {
            
            ZStack {
                
                Color(
                    red: 0.95,
                    green: 0.98,
                    blue: 0.97
                )
                .ignoresSafeArea()
                
                ScrollView(showsIndicators: false) {
                    
                    VStack(
                        alignment: .leading,
                        spacing: 0
                    ) {
                        
                        // MARK: - Header
                        
                        Text("Activity")
                            .font(
                                .system(
                                    size: 22,
                                    weight: .bold
                                )
                            )
                            .foregroundStyle(.black)
                            .padding(.top, 15)
                        
                        Text(
                            "Keep track of your community involvement."
                        )
                        .font(.system(size: 9))
                        .foregroundStyle(.gray)
                        .padding(.top, 4)
                        
                        
                        // MARK: - Summary Cards
                        
                        HStack(spacing: 9) {
                            
                            ActivitySummaryCard(
                                title: "Requests",
                                value: "\(myRequests.count)",
                                icon: "hand.raised.fill"
                            )
                            
                            ActivitySummaryCard(
                                title: "Helped",
                                value: "\(helpedRequests.count)",
                                icon: "hands.sparkles.fill"
                            )
                            
                            ActivitySummaryCard(
                                title: "Total",
                                value: "\(totalActivity)",
                                icon: "chart.bar.fill"
                            )
                        }
                        .padding(.top, 18)
                        
                        
                        // MARK: - Recent Activity
                        
                        Text("Recent Activity")
                            .font(
                                .system(
                                    size: 13,
                                    weight: .bold
                                )
                            )
                            .foregroundStyle(.black)
                            .padding(.top, 25)
                        
                        
                        if myRequests.isEmpty && helpedRequests.isEmpty {
                            
                            EmptyActivityView()
                                .padding(.top, 35)
                            
                        } else {
                            
                            VStack(spacing: 9) {

                                ForEach(
                                    activityItems
                                ) { item in

                                    NavigationLink {

                                        if item.isHelped {

                                            HelpStatusView(
                                                request: item.request
                                            )

                                        } else {

                                            RequestDetailsView(
                                                request: item.request
                                            )
                                        }

                                    } label: {

                                        ActivityRow(
                                            item: item
                                        )
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                            .padding(.top, 10)
                        }
                        
                        Spacer(minLength: 30)
                    }
                    .padding(.horizontal, 20)
                }
            }
            .navigationTitle("Activity")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    
    // MARK: - Activity Items
    
    private var activityItems: [ActivityItem] {
        
        var items: [ActivityItem] = []
        
        for request in myRequests {

            items.append(
                ActivityItem(
                    id: request.id,
                    title: request.title,
                    subtitle: "You posted a help request",
                    icon: "hand.raised.fill",
                    status: request.status.rawValue,
                    request: request,
                    isHelped: false
                )
            )
        }

        for request in helpedRequests {

            items.append(
                ActivityItem(
                    id: request.id,
                    title: request.title,
                    subtitle: "You offered to help",
                    icon: "hands.sparkles.fill",
                    status: request.status.rawValue,
                    request: request,
                    isHelped: true
                )
            )
        }

        return items
    }
}


// MARK: - Activity Item

struct ActivityItem: Identifiable {

    let id: UUID
    let title: String
    let subtitle: String
    let icon: String
    let status: String
    let request: CommunityRequest
    let isHelped: Bool
}


// MARK: - Summary Card

struct ActivitySummaryCard: View {
    
    let title: String
    let value: String
    let icon: String
    
    var body: some View {
        
        VStack(
            alignment: .leading,
            spacing: 7
        ) {
            
            Image(
                systemName: icon
            )
            .font(.system(size: 12))
            .foregroundStyle(
                Color(
                    red: 0.00,
                    green: 0.55,
                    blue: 0.45
                )
            )
            
            Text(value)
                .font(
                    .system(
                        size: 17,
                        weight: .bold
                    )
                )
                .foregroundStyle(.black)
            
            Text(title)
                .font(.system(size: 7))
                .foregroundStyle(.gray)
        }
        .frame(
            maxWidth: .infinity,
            alignment: .leading
        )
        .padding(11)
        .background(.white)
        .clipShape(
            RoundedRectangle(
                cornerRadius: 13
            )
        )
    }
}


// MARK: - Activity Row

struct ActivityRow: View {
    
    let item: ActivityItem
    
    var body: some View {
        
        HStack(spacing: 11) {
            
            ZStack {
                
                Circle()
                    .fill(
                        Color(
                            red: 0.00,
                            green: 0.55,
                            blue: 0.45
                        )
                        .opacity(0.10)
                    )
                
                Image(
                    systemName: item.icon
                )
                .font(.system(size: 11))
                .foregroundStyle(
                    Color(
                        red: 0.00,
                        green: 0.55,
                        blue: 0.45
                    )
                )
            }
            .frame(
                width: 39,
                height: 39
            )
            
            VStack(
                alignment: .leading,
                spacing: 4
            ) {
                
                Text(item.title)
                    .font(
                        .system(
                            size: 9,
                            weight: .semibold
                        )
                    )
                    .foregroundStyle(.black)
                    .lineLimit(1)
                
                Text(item.subtitle)
                    .font(.system(size: 7))
                    .foregroundStyle(.gray)
            }
            
            Spacer()
            
            Text(item.status)
                .font(
                    .system(
                        size: 6,
                        weight: .semibold
                    )
                )
                .foregroundStyle(
                    Color(
                        red: 0.00,
                        green: 0.55,
                        blue: 0.45
                    )
                )
                .padding(.horizontal, 7)
                .padding(.vertical, 5)
                .background(
                    Color(
                        red: 0.00,
                        green: 0.55,
                        blue: 0.45
                    )
                    .opacity(0.08)
                )
                .clipShape(Capsule())
        }
        .padding(.horizontal, 12)
        .frame(height: 64)
        .background(.white)
        .clipShape(
            RoundedRectangle(
                cornerRadius: 14
            )
        )
    }
}


// MARK: - Empty Activity

struct EmptyActivityView: View {
    
    var body: some View {
        
        VStack(spacing: 10) {
            
            Image(
                systemName: "clock.arrow.circlepath"
            )
            .font(.system(size: 32))
            .foregroundStyle(
                .gray.opacity(0.45)
            )
            
            Text("No Activity Yet")
                .font(
                    .system(
                        size: 14,
                        weight: .bold
                    )
                )
                .foregroundStyle(.black)
            
            Text(
                "Your requests and helping activities will appear here."
            )
            .font(.system(size: 9))
            .foregroundStyle(.gray)
            .multilineTextAlignment(.center)
            .padding(.horizontal, 30)
        }
        .frame(
            maxWidth: .infinity
        )
    }
}


// MARK: - Preview

#Preview {
    
    ActivityView()
        .environment(BayanihanController())
}
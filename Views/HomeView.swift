import SwiftUI

struct HomeView: View {
    
    @Environment(BayanihanController.self) private var controller
    
    private var openRequests: [CommunityRequest] {
        controller.requests.filter {
            $0.status == .open
        }
    }
    
    private var activeHelpRequests: [CommunityRequest] {
        controller.requests.filter {
            $0.status == .inDiscussion ||
            $0.status == .confirmed ||
            $0.status == .inProgress
        }
    }

    @State private var showPostRequest = false

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
                        
                        HStack {
                            
                            VStack(
                                alignment: .leading,
                                spacing: 4
                            ) {
                                
                                Text("Good day,")
                                    .font(.system(size: 9))
                                    .foregroundStyle(.gray)
                                
                                Text(controller.currentUser.name)
                                    .font(
                                        .system(
                                            size: 21,
                                            weight: .bold
                                        )
                                    )
                                    .foregroundStyle(.black)
                            }
                            
                            Spacer()
                            
                            NavigationLink {
                                
                                NotificationsView()
                                
                            } label: {
                                
                                Image(
                                    systemName: "bell"
                                )
                                .font(.system(size: 15))
                                .foregroundStyle(.black)
                                .frame(
                                    width: 40,
                                    height: 40
                                )
                                .background(.white)
                                .clipShape(Circle())
                            }
                            .buttonStyle(.plain)
                        }
                        .padding(.top, 15)
                        
                        
                        // MARK: - Welcome Card
                        
                        VStack(
                            alignment: .leading,
                            spacing: 10
                        ) {
                            
                            HStack {
                                
                                VStack(
                                    alignment: .leading,
                                    spacing: 7
                                ) {
                                    
                                    Text("Together,")
                                        .font(
                                            .system(
                                                size: 18,
                                                weight: .bold
                                            )
                                        )
                                        .foregroundStyle(.white)
                                    
                                    Text(
                                        "we can make a difference."
                                    )
                                    .font(.system(size: 10))
                                    .foregroundStyle(.white.opacity(0.9))
                                    
                                    Text(
                                        "Help a neighbor. Ask for help. Build a stronger community."
                                    )
                                    .font(.system(size: 8))
                                    .foregroundStyle(.white.opacity(0.85))
                                    .lineLimit(2)
                                }
                                
                                Spacer()
                                
                                Image(
                                    systemName: "hands.sparkles.fill"
                                )
                                .font(.system(size: 38))
                                .foregroundStyle(.white.opacity(0.9))
                            }
                        }
                        .padding(18)
                        .background(
                            Color(
                                red: 0.00,
                                green: 0.55,
                                blue: 0.45
                            )
                        )
                        .clipShape(
                            RoundedRectangle(
                                cornerRadius: 18
                            )
                        )
                        .padding(.top, 20)
                        
                        
                        // MARK: - Quick Actions
                        
                        Text("Quick Actions")
                            .font(
                                .system(
                                    size: 14,
                                    weight: .bold
                                )
                            )
                            .foregroundStyle(.black)
                            .padding(.top, 23)
                        
                        HStack(spacing: 10) {
                            
                            Button {
                                showPostRequest = true
                            } label: {

                                HomeActionCard(
                                    title: "Ask for Help",
                                    subtitle: "Post a request",
                                    icon: "megaphone.fill"
                                )
                            }
                            .buttonStyle(.plain)
                            
                            NavigationLink {
                                
                                RequestsView()
                                
                            } label: {
                                
                                HomeActionCard(
                                    title: "Help Others",
                                    subtitle: "Find requests",
                                    icon: "hands.sparkles.fill"
                                )
                            }
                            .buttonStyle(.plain)
                        }
                        .padding(.top, 11)
                        
                        
                        // MARK: - Community Stats
                        
                        Text("Your Impact")
                            .font(
                                .system(
                                    size: 14,
                                    weight: .bold
                                )
                            )
                            .foregroundStyle(.black)
                            .padding(.top, 24)
                        
                        HStack(spacing: 9) {
                            
                            ImpactCard(
                                value: "\(controller.currentUser.requestsHelped)",
                                title: "Helped"
                            )
                            
                            ImpactCard(
                                value: "\(controller.currentUser.requestsPosted)",
                                title: "Posted"
                            )
                            
                            ImpactCard(
                                value: "\(controller.currentUser.communityPoints)",
                                title: "Points"
                            )
                        }
                        .padding(.top, 11)
                        
                        
                        // MARK: - Open Requests
                        
                        HStack {
                            
                            Text("Requests Near You")
                                .font(
                                    .system(
                                        size: 14,
                                        weight: .bold
                                    )
                                )
                                .foregroundStyle(.black)
                            
                            Spacer()
                            
                            NavigationLink {
                                
                                RequestsView()
                                
                            } label: {
                                
                                Text("See All")
                                    .font(
                                        .system(
                                            size: 8,
                                            weight: .bold
                                        )
                                    )
                                    .foregroundStyle(
                                        Color(
                                            red: 0.00,
                                            green: 0.55,
                                            blue: 0.45
                                        )
                                    )
                            }
                        }
                        .padding(.top, 24)
                        
                        
                        if openRequests.isEmpty {
                            
                            HomeEmptyRequestView()
                                .padding(.top, 12)
                            
                        } else {
                            
                            LazyVStack(
                                spacing: 10
                            ) {
                                
                                ForEach(
                                    Array(
                                        openRequests.prefix(3)
                                    )
                                ) { request in
                                    
                                    NavigationLink {
                                        
                                        RequestDetailsView(
                                            request: request
                                        )
                                        
                                    } label: {
                                        
                                        HomeRequestCard(
                                            request: request
                                        )
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                            .padding(.top, 11)
                        }
                        
                        
                        // MARK: - Active Help
                        
                        if !activeHelpRequests.isEmpty {
                            
                            Text("Your Active Help")
                                .font(
                                    .system(
                                        size: 14,
                                        weight: .bold
                                    )
                                )
                                .foregroundStyle(.black)
                                .padding(.top, 24)
                            
                            LazyVStack(
                                spacing: 10
                            ) {
                                
                                ForEach(
                                    Array(
                                        activeHelpRequests.prefix(2)
                                    )
                                ) { request in
                                    
                                    NavigationLink {
                                        
                                        HelpStatusView(
                                            request: request
                                        )
                                        
                                    } label: {
                                        
                                        ActiveHelpCard(
                                            request: request
                                        )
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                            .padding(.top, 11)
                        }
                        
                        Spacer(minLength: 35)
                    }
                    .padding(.horizontal, 20)
                }
            }
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $showPostRequest) {
                PostRequestView()
            }
        }
    }
}


// MARK: - Home Action Card

struct HomeActionCard: View {
    
    let title: String
    let subtitle: String
    let icon: String
    
    var body: some View {
        
        VStack(
            alignment: .leading,
            spacing: 7
        ) {
            
            Image(systemName: icon)
                .font(.system(size: 18))
                .foregroundStyle(
                    Color(
                        red: 0.00,
                        green: 0.55,
                        blue: 0.45
                    )
                )
            
            Text(title)
                .font(
                    .system(
                        size: 10,
                        weight: .bold
                    )
                )
                .foregroundStyle(.black)
            
            Text(subtitle)
                .font(.system(size: 8))
                .foregroundStyle(.gray)
        }
        .frame(
            maxWidth: .infinity,
            alignment: .leading
        )
        .frame(height: 105)
        .padding(14)
        .background(.white)
        .clipShape(
            RoundedRectangle(
                cornerRadius: 14
            )
        )
    }
}


// MARK: - Impact Card

struct ImpactCard: View {
    
    let value: String
    let title: String
    
    var body: some View {
        
        VStack(spacing: 5) {
            
            Text(value)
                .font(
                    .system(
                        size: 17,
                        weight: .bold
                    )
                )
                .foregroundStyle(
                    Color(
                        red: 0.00,
                        green: 0.55,
                        blue: 0.45
                    )
                )
            
            Text(title)
                .font(.system(size: 8))
                .foregroundStyle(.gray)
        }
        .frame(
            maxWidth: .infinity
        )
        .frame(height: 68)
        .background(.white)
        .clipShape(
            RoundedRectangle(
                cornerRadius: 12
            )
        )
    }
}


// MARK: - Home Request Card

struct HomeRequestCard: View {
    
    let request: CommunityRequest
    
    var body: some View {
        
        HStack(spacing: 12) {
            
            ZStack {
                
                RoundedRectangle(
                    cornerRadius: 11
                )
                .fill(
                    Color(
                        red: 0.84,
                        green: 0.93,
                        blue: 0.90
                    )
                )
                
                Image(
                    systemName: request.category.icon
                )
                .font(.system(size: 16))
                .foregroundStyle(
                    Color(
                        red: 0.00,
                        green: 0.55,
                        blue: 0.45
                    )
                )
            }
            .frame(
                width: 55,
                height: 55
            )
            
            VStack(
                alignment: .leading,
                spacing: 5
            ) {
                
                Text(request.category.rawValue)
                    .font(
                        .system(
                            size: 7,
                            weight: .bold
                        )
                    )
                    .foregroundStyle(
                        Color(
                            red: 0.00,
                            green: 0.55,
                            blue: 0.45
                        )
                    )
                
                Text(request.title)
                    .font(
                        .system(
                            size: 10,
                            weight: .bold
                        )
                    )
                    .foregroundStyle(.black)
                    .lineLimit(1)
                
                Label(
                    request.location,
                    systemImage: "mappin.and.ellipse"
                )
                .font(.system(size: 7))
                .foregroundStyle(.gray)
            }
            
            Spacer()
            
            Image(
                systemName: "chevron.right"
            )
            .font(.system(size: 8))
            .foregroundStyle(.gray)
        }
        .padding(11)
        .background(.white)
        .clipShape(
            RoundedRectangle(
                cornerRadius: 14
            )
        )
    }
}


// MARK: - Active Help Card

struct ActiveHelpCard: View {
    
    let request: CommunityRequest
    
    var body: some View {
        
        HStack(spacing: 11) {
            
            Image(
                systemName: "hands.sparkles.fill"
            )
            .font(.system(size: 15))
            .foregroundStyle(
                Color(
                    red: 0.00,
                    green: 0.55,
                    blue: 0.45
                )
            )
            .frame(
                width: 42,
                height: 42
            )
            .background(
                Color(
                    red: 0.84,
                    green: 0.93,
                    blue: 0.90
                )
            )
            .clipShape(Circle())
            
            VStack(
                alignment: .leading,
                spacing: 4
            ) {
                
                Text(request.title)
                    .font(
                        .system(
                            size: 10,
                            weight: .bold
                        )
                    )
                    .foregroundStyle(.black)
                    .lineLimit(1)
                
                Text(
                    request.helperName == nil
                        ? "Help is being arranged"
                        : "Helping \(request.requesterName)"
                )
                .font(.system(size: 8))
                .foregroundStyle(.gray)
                
                Text(request.status.rawValue)
                    .font(
                        .system(
                            size: 7,
                            weight: .bold
                        )
                    )
                    .foregroundStyle(
                        Color(
                            red: 0.00,
                            green: 0.55,
                            blue: 0.45
                        )
                    )
            }
            
            Spacer()
            
            Image(
                systemName: "chevron.right"
            )
            .font(.system(size: 8))
            .foregroundStyle(.gray)
        }
        .padding(11)
        .background(.white)
        .clipShape(
            RoundedRectangle(
                cornerRadius: 14
            )
        )
    }
}


// MARK: - Empty Requests

struct HomeEmptyRequestView: View {
    
    var body: some View {
        
        VStack(spacing: 8) {
            
            Image(
                systemName: "hands.sparkles"
            )
            .font(.system(size: 25))
            .foregroundStyle(.gray.opacity(0.5))
            
            Text("No open requests right now")
                .font(
                    .system(
                        size: 11,
                        weight: .semibold
                    )
                )
                .foregroundStyle(.black)
            
            Text(
                "Check again later or post a request yourself."
            )
            .font(.system(size: 8))
            .foregroundStyle(.gray)
            .multilineTextAlignment(.center)
        }
        .frame(
            maxWidth: .infinity
        )
        .padding(.vertical, 25)
    }
}


// MARK: - Preview

#Preview {
    
    HomeView()
        .environment(BayanihanController())
}
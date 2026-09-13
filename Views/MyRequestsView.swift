import SwiftUI

struct MyRequestsView: View {
    
    @Environment(BayanihanController.self) private var controller
    
    private var myRequests: [CommunityRequest] {
        controller.requests.filter {
            $0.requesterUsername == controller.currentUser.username
        }
    }
    
    var body: some View {

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
                        
                        Text("My Requests")
                            .font(
                                .system(
                                    size: 22,
                                    weight: .bold
                                )
                            )
                            .foregroundStyle(.black)
                            .padding(.top, 15)
                        
                        Text(
                            "Manage the help requests you have posted."
                        )
                        .font(.system(size: 9))
                        .foregroundStyle(.gray)
                        .padding(.top, 4)
                        
                        
                        // MARK: - Request Count
                        
                        HStack {
                            
                            Image(
                                systemName: "hand.raised.fill"
                            )
                            .font(.system(size: 10))
                            
                            Text(
                                "\(myRequests.count) request\(myRequests.count == 1 ? "" : "s") posted"
                            )
                            .font(
                                .system(
                                    size: 8,
                                    weight: .semibold
                                )
                            )
                            
                            Spacer()
                        }
                        .foregroundStyle(
                            Color(
                                red: 0.00,
                                green: 0.55,
                                blue: 0.45
                            )
                        )
                        .padding(.horizontal, 12)
                        .frame(height: 38)
                        .background(
                            Color(
                                red: 0.00,
                                green: 0.55,
                                blue: 0.45
                            )
                            .opacity(0.08)
                        )
                        .clipShape(
                            RoundedRectangle(
                                cornerRadius: 10
                            )
                        )
                        .padding(.top, 17)
                        
                        
                        // MARK: - Requests
                        
                        if myRequests.isEmpty {
                            
                            EmptyMyRequestsView()
                                .padding(.top, 45)
                            
                        } else {
                            
                            LazyVStack(
                                spacing: 10
                            ) {
                                
                                ForEach(myRequests) { request in
                                    
                                    NavigationLink {
                                        
                                        RequestDetailsView(
                                            request: request
                                        )
                                        
                                    } label: {
                                        
                                        MyRequestCard(
                                            request: request
                                        )
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                            .padding(.top, 12)
                        }
                        
                        Spacer(minLength: 30)
                    }
                    .padding(.horizontal, 20)
                }
            }
            .navigationTitle("My Requests")
            .navigationBarTitleDisplayMode(.inline)
    }
}


// MARK: - My Request Card

struct MyRequestCard: View {
    
    let request: CommunityRequest
    
    var body: some View {
        
        VStack(
            alignment: .leading,
            spacing: 9
        ) {
            
            HStack(spacing: 10) {
                
                ZStack {
                    
                    RoundedRectangle(
                        cornerRadius: 10
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
                    .font(.system(size: 13))
                    .foregroundStyle(
                        Color(
                            red: 0.00,
                            green: 0.55,
                            blue: 0.45
                        )
                    )
                }
                .frame(
                    width: 43,
                    height: 43
                )
                
                VStack(
                    alignment: .leading,
                    spacing: 4
                ) {
                    
                    Text(
                        request.category.rawValue.uppercased()
                    )
                    .font(
                        .system(
                            size: 6,
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
                        .lineLimit(2)
                }
                
                Spacer()
                
                MyRequestStatusBadge(
                    status: request.status
                )
            }
            
            
            Text(request.description)
                .font(.system(size: 8))
                .foregroundStyle(.gray)
                .lineLimit(2)
            
            
            HStack(spacing: 12) {
                
                Label(
                    request.location,
                    systemImage: "mappin.and.ellipse"
                )
                
                Label(
                    request.time,
                    systemImage: "clock"
                )
                
                Spacer()
            }
            .font(.system(size: 7))
            .foregroundStyle(.gray)
            
            
            if let helperName = request.helperName {
                
                HStack(spacing: 5) {
                    
                    Image(
                        systemName: "hands.sparkles.fill"
                    )
                    .font(.system(size: 7))
                    
                    Text(
                        "Helper: \(helperName)"
                    )
                    .font(
                        .system(
                            size: 7,
                            weight: .semibold
                        )
                    )
                }
                .foregroundStyle(
                    Color(
                        red: 0.00,
                        green: 0.55,
                        blue: 0.45
                    )
                )
            }
        }
        .padding(13)
        .background(.white)
        .clipShape(
            RoundedRectangle(
                cornerRadius: 14
            )
        )
    }
}


// MARK: - Status Badge

struct MyRequestStatusBadge: View {
    
    let status: CommunityRequestStatus
    
    var body: some View {
        
        Text(status.rawValue.uppercased())
            .font(
                .system(
                    size: 6,
                    weight: .bold
                )
            )
            .foregroundStyle(statusColor)
            .padding(.horizontal, 7)
            .padding(.vertical, 5)
            .background(
                statusColor.opacity(0.08)
            )
            .clipShape(Capsule())
    }
    
    private var statusColor: Color {
        
        switch status {
        case .open:
            return Color(
                red: 0.00,
                green: 0.55,
                blue: 0.45
            )
            
        case .inDiscussion:
            return .orange

        case .confirmed:
            return .orange

        case .inProgress:
            return Color(
                red: 0.00,
                green: 0.55,
                blue: 0.45
            )

        case .completed:
            return .gray
        }
    }
}


// MARK: - Empty State

struct EmptyMyRequestsView: View {
    
    var body: some View {
        
        VStack(spacing: 10) {
            
            Image(
                systemName: "hand.raised.slash"
            )
            .font(.system(size: 34))
            .foregroundStyle(
                .gray.opacity(0.45)
            )
            
            Text("No Requests Yet")
                .font(
                    .system(
                        size: 14,
                        weight: .bold
                    )
                )
                .foregroundStyle(.black)
            
            Text(
                "Requests you post for your community will appear here."
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
    
    MyRequestsView()
        .environment(BayanihanController())
}
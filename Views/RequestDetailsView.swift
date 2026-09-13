import SwiftUI

struct RequestDetailsView: View {
    
    @Environment(BayanihanController.self) private var controller
    @Environment(\.dismiss) private var dismiss
    
    let request: CommunityRequest
    
    @State private var showHelpAlert = false
    @State private var showChat = false
    
    private var isMyRequest: Bool {
        request.requesterUsername == controller.currentUser.username
    }
    
    var body: some View {
        
        ScrollView(showsIndicators: false) {
            
            VStack(
                alignment: .leading,
                spacing: 0
            ) {
                
                // MARK: - Category & Status
                
                HStack {
                    
                    HStack(spacing: 6) {
                        
                        Image(
                            systemName: request.category.icon
                        )
                        .font(.system(size: 10))
                        
                        Text(
                            request.category.rawValue
                        )
                        .font(
                            .system(
                                size: 8,
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
                    
                    Spacer()
                    
                    Text(
                        request.status.rawValue.uppercased()
                    )
                    .font(
                        .system(
                            size: 7,
                            weight: .bold
                        )
                    )
                    .foregroundStyle(statusColor)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 5)
                    .background(
                        statusColor.opacity(0.10)
                    )
                    .clipShape(Capsule())
                }
                .padding(.top, 18)
                
                
                // MARK: - Title
                
                Text(request.title)
                    .font(
                        .system(
                            size: 21,
                            weight: .bold
                        )
                    )
                    .foregroundStyle(.black)
                    .padding(.top, 14)
                
                
                // MARK: - Description
                
                Text(request.description)
                    .font(.system(size: 10))
                    .foregroundStyle(.gray)
                    .lineSpacing(3)
                    .padding(.top, 9)
                
                
                // MARK: - Request Information
                
                VStack(
                    alignment: .leading,
                    spacing: 12
                ) {
                    
                    DetailInfoRow(
                        icon: "mappin.and.ellipse",
                        title: "Location",
                        value: request.location
                    )
                    
                    DetailInfoRow(
                        icon: "clock",
                        title: "Preferred Time",
                        value: request.time
                    )
                    
                    DetailInfoRow(
                        icon: "person.2.fill",
                        title: "People Needed",
                        value: "\(request.peopleNeeded)"
                    )
                    
                    DetailInfoRow(
                        icon: "exclamationmark.triangle.fill",
                        title: "Urgency",
                        value: request.urgency.rawValue
                    )
                }
                .padding(14)
                .background(.white)
                .clipShape(
                    RoundedRectangle(
                        cornerRadius: 14
                    )
                )
                .padding(.top, 20)
                
                
                // MARK: - Requester
                
                Text("Posted By")
                    .font(
                        .system(
                            size: 13,
                            weight: .bold
                        )
                    )
                    .foregroundStyle(.black)
                    .padding(.top, 23)
                
                HStack(spacing: 10) {
                    
                    ZStack {
                        
                        Circle()
                            .fill(
                                Color(
                                    red: 0.84,
                                    green: 0.93,
                                    blue: 0.90
                                )
                            )
                        
                        Text(
                            initials(request.requesterName)
                        )
                        .font(
                            .system(
                                size: 12,
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
                    .frame(
                        width: 43,
                        height: 43
                    )
                    
                    VStack(
                        alignment: .leading,
                        spacing: 3
                    ) {
                        
                        Text(request.requesterName)
                            .font(
                                .system(
                                    size: 10,
                                    weight: .bold
                                )
                            )
                            .foregroundStyle(.black)
                        
                        Text(request.requesterUsername)
                            .font(.system(size: 8))
                            .foregroundStyle(.gray)
                    }
                    
                    Spacer()
                }
                .padding(13)
                .background(.white)
                .clipShape(
                    RoundedRectangle(
                        cornerRadius: 14
                    )
                )
                .padding(.top, 10)
                
                
                // MARK: - Helper
                
                if let helperName = request.helperName {
                    
                    Text("Helper")
                        .font(
                            .system(
                                size: 13,
                                weight: .bold
                            )
                        )
                        .foregroundStyle(.black)
                        .padding(.top, 23)
                    
                    HStack(spacing: 10) {
                        
                        ZStack {
                            
                            Circle()
                                .fill(
                                    Color(
                                        red: 0.84,
                                        green: 0.93,
                                        blue: 0.90
                                    )
                                )
                            
                            Text(
                                initials(helperName)
                            )
                            .font(
                                .system(
                                    size: 12,
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
                        .frame(
                            width: 43,
                            height: 43
                        )
                        
                        VStack(
                            alignment: .leading,
                            spacing: 3
                        ) {
                            
                            Text(helperName)
                                .font(
                                    .system(
                                        size: 10,
                                        weight: .bold
                                    )
                                )
                                .foregroundStyle(.black)
                            
                            Text("Community helper")
                                .font(.system(size: 8))
                                .foregroundStyle(.gray)
                        }
                        
                        Spacer()
                    }
                    .padding(13)
                    .background(.white)
                    .clipShape(
                        RoundedRectangle(
                            cornerRadius: 14
                        )
                    )
                    .padding(.top, 10)
                }
                
                
                // MARK: - Action
                
                if isMyRequest {
                    
                    NavigationLink {
                        
                        HelpStatusView(
                            request: request
                        )
                        
                    } label: {
                        
                        ActionButtonLabel(
                            icon: "chart.line.uptrend.xyaxis",
                            title: "View Help Status"
                        )
                    }
                    .buttonStyle(.plain)
                    .padding(.top, 23)
                    
                } else if request.status == .open {
                    
                    Button {
                        showHelpAlert = true
                    } label: {
                        
                        ActionButtonLabel(
                            icon: "hands.sparkles.fill",
                            title: "Offer to Help"
                        )
                    }
                    .buttonStyle(.plain)
                    .padding(.top, 23)
                    
                } else {
                    
                    NavigationLink {
                        
                        ChatView(
                            request: request
                        )
                        
                    } label: {
                        
                        ActionButtonLabel(
                            icon: "message.fill",
                            title: "Open Chat"
                        )
                    }
                    .buttonStyle(.plain)
                    .padding(.top, 23)
                }
                
                Spacer(minLength: 30)
            }
            .padding(.horizontal, 20)
        }
        .background(
            Color(
                red: 0.95,
                green: 0.98,
                blue: 0.97
            )
            .ignoresSafeArea()
        )
        .navigationTitle("Request Details")
        .navigationBarTitleDisplayMode(.inline)
        .alert(
            "Offer to Help?",
            isPresented: $showHelpAlert
        ) {
            
            Button("Cancel", role: .cancel) {
                
            }
            
            Button("Offer to Help") {
                offerToHelp()
            }
            
        } message: {
            
            Text(
                "You can coordinate with the requester through chat."
            )
        }
    }
    
    
    // MARK: - Offer to Help
    
    private func offerToHelp() {
        
        controller.offerHelp(
            for: request.id
        )
    }
    
    
    // MARK: - Status Color
    
    private var statusColor: Color {
        
        switch request.status {
            
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
    
    
    // MARK: - Initials
    
    private func initials(
        _ name: String
    ) -> String {
        
        let words = name.split(separator: " ")
        
        let letters = words.prefix(2).compactMap {
            $0.first
        }
        
        if letters.isEmpty {
            return "?"
        }
        
        return String(letters)
    }
}


// MARK: - Detail Info Row

struct DetailInfoRow: View {
    
    let icon: String
    let title: String
    let value: String
    
    var body: some View {
        
        HStack(spacing: 10) {
            
            Image(systemName: icon)
                .font(.system(size: 10))
                .foregroundStyle(
                    Color(
                        red: 0.00,
                        green: 0.55,
                        blue: 0.45
                    )
                )
                .frame(width: 18)
            
            VStack(
                alignment: .leading,
                spacing: 2
            ) {
                
                Text(title)
                    .font(.system(size: 7))
                    .foregroundStyle(.gray)
                
                Text(value)
                    .font(
                        .system(
                            size: 9,
                            weight: .semibold
                        )
                    )
                    .foregroundStyle(.black)
            }
            
            Spacer()
        }
    }
}


// MARK: - Action Button

struct ActionButtonLabel: View {
    
    let icon: String
    let title: String
    
    var body: some View {
        
        HStack(spacing: 8) {
            
            Image(systemName: icon)
                .font(.system(size: 10))
            
            Text(title)
                .font(
                    .system(
                        size: 11,
                        weight: .bold
                    )
                )
        }
        .foregroundStyle(.white)
        .frame(
            maxWidth: .infinity
        )
        .frame(height: 50)
        .background(
            Color(
                red: 0.00,
                green: 0.55,
                blue: 0.45
            )
        )
        .clipShape(
            RoundedRectangle(
                cornerRadius: 14
            )
        )
    }
}


// MARK: - Preview

#Preview {
    
    NavigationStack {
        
        RequestDetailsView(
            request: CommunityRequest(
                id: UUID(),
                title: "Help Needed",
                description: "A community member needs assistance.",
                category: .other,
                location: "Brgy. San Isidro",
                time: "9:00 AM",
                peopleNeeded: 1,
                urgency: .normal,
                requesterName: "Maria Santos",
                requesterUsername: "@maria",
                status: .open,
                helperName: nil
            )
        )
        .environment(BayanihanController())
    }
}
import SwiftUI

struct HelpStatusView: View {
    
    @Environment(BayanihanController.self) private var controller
    
    let request: CommunityRequest
    
    @Environment(\.dismiss) private var dismiss
    
    @State private var showCompletionAlert = false
    
    private var isRequester: Bool {
        request.requesterUsername == controller.currentUser.username
    }
    
    private var statusTitle: String {
        
        switch request.status {
        case .open:
            return "Waiting for a Helper"

        case .inDiscussion:
            return "Helper Connected"

        case .confirmed:
            return "Help Confirmed"

        case .inProgress:
            return "Help In Progress"

        case .completed:
            return "Request Completed"
        }
    }
    
    private var statusMessage: String {
        
        switch request.status {
        case .open:
            return "Your request is currently visible to community members who may be able to help."

        case .inDiscussion:
            return "A community member has offered to help with this request."

        case .confirmed:
            return "The details for this help have been confirmed."

        case .inProgress:
            return "Help is currently underway for this request."

        case .completed:
            return "This request has been completed. Thank you for helping your community."
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
                    
                    // MARK: - Status Icon
                    
                    VStack(spacing: 12) {
                        
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
                                systemName: statusIcon
                            )
                            .font(.system(size: 28))
                            .foregroundStyle(
                                Color(
                                    red: 0.00,
                                    green: 0.55,
                                    blue: 0.45
                                )
                            )
                        }
                        .frame(
                            width: 78,
                            height: 78
                        )
                        
                        Text(statusTitle)
                            .font(
                                .system(
                                    size: 17,
                                    weight: .bold
                                )
                            )
                            .foregroundStyle(.black)
                            .multilineTextAlignment(.center)
                        
                        Text(statusMessage)
                            .font(.system(size: 9))
                            .foregroundStyle(.gray)
                            .multilineTextAlignment(.center)
                            .lineSpacing(2)
                            .padding(.horizontal, 25)
                    }
                    .frame(
                        maxWidth: .infinity
                    )
                    .padding(.top, 25)
                    
                    
                    // MARK: - Request Summary
                    
                    Text("Request")
                        .font(
                            .system(
                                size: 13,
                                weight: .bold
                            )
                        )
                        .foregroundStyle(.black)
                        .padding(.top, 28)
                    
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

                                HStack(spacing: 5) {

                                    UrgencyBadge(
                                        urgency: request.urgency
                                    )

                                    MyRequestStatusBadge(
                                        status: request.status
                                    )
                                }

                                Text(request.title)
                                    .font(
                                        .system(
                                            size: 10,
                                            weight: .semibold
                                        )
                                    )
                                    .foregroundStyle(.black)
                                    .lineLimit(2)
                            }

                            Spacer()
                        }

                        Label(
                            request.requesterName,
                            systemImage: "person.fill"
                        )
                        .font(.system(size: 7))
                        .foregroundStyle(.gray)

                        Text(request.description)
                            .font(.system(size: 8))
                            .foregroundStyle(.gray)
                            .lineSpacing(2)

                        Divider()

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

                        Text(timeAgo)
                            .font(.system(size: 6))
                            .foregroundStyle(.gray.opacity(0.7))
                    }
                    .padding(14)
                    .background(.white)
                    .clipShape(
                        RoundedRectangle(
                            cornerRadius: 14
                        )
                    )
                    .padding(.top, 10)
                    
                    
                    // MARK: - Helper Information
                    
                    if let helperName = request.helperName {
                        
                        Text(
                            isRequester
                                ? "Helper"
                                : "Your Help"
                        )
                        .font(
                            .system(
                                size: 13,
                                weight: .bold
                            )
                        )
                        .foregroundStyle(.black)
                        .padding(.top, 23)
                        
                        HStack(spacing: 11) {
                            
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
                                        size: 13,
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
                                            weight: .semibold
                                        )
                                    )
                                    .foregroundStyle(.black)
                                
                                Text(
                                    isRequester
                                        ? "Community helper"
                                        : "Thank you for offering to help"
                                )
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
                    
                    
                    // MARK: - Progress
                    
                    Text("Status")
                        .font(
                            .system(
                                size: 13,
                                weight: .bold
                            )
                        )
                        .foregroundStyle(.black)
                        .padding(.top, 23)
                    
                    VStack(spacing: 0) {

                        ForEach(
                            Array(
                                timelineSteps.enumerated()
                            ),
                            id: \.offset
                        ) { index, step in

                            StatusStepRow(
                                title: step.title,
                                subtitle: step.subtitle,
                                icon: step.icon,
                                isCompleted:
                                    statusRank(request.status) >=
                                    statusRank(step.status),
                                isCurrent:
                                    statusRank(request.status) ==
                                    statusRank(step.status),
                                isLast: index == timelineSteps.count - 1
                            )
                        }
                    }
                    .padding(.horizontal, 13)
                    .padding(.vertical, 8)
                    .background(.white)
                    .clipShape(
                        RoundedRectangle(
                            cornerRadius: 14
                        )
                    )
                    .padding(.top, 10)
                    
                    
                    // MARK: - Help Agreement

                    if isRequester && (
                        request.status == .inDiscussion ||
                        request.status == .confirmed ||
                        request.status == .inProgress
                    ) {

                        NavigationLink {

                            HelpAgreementView(
                                request: request
                            )

                        } label: {

                            HStack(spacing: 8) {

                                Image(
                                    systemName: "doc.text.fill"
                                )

                                Text("Help Agreement")
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
                        .buttonStyle(.plain)
                        .padding(.top, 23)
                    }


                    // MARK: - Start Help

                    if isRequester && request.status == .confirmed {

                        Button {
                            controller.startHelp(
                                for: request.id
                            )
                        } label: {

                            HStack(spacing: 8) {

                                Image(
                                    systemName: "figure.walk"
                                )

                                Text("Start Help")
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
                        .buttonStyle(.plain)
                        .padding(.top, 23)
                    }


                    // MARK: - Completion Button

                    if isRequester && request.status == .inProgress {

                        Button {
                            showCompletionAlert = true
                        } label: {
                            
                            HStack(spacing: 8) {
                                
                                Image(
                                    systemName: "checkmark.seal.fill"
                                )
                                
                                Text("Mark as Completed")
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
                        .buttonStyle(.plain)
                        .padding(.top, 23)
                    }
                    
                    Spacer(minLength: 30)
                }
                .padding(.horizontal, 20)
            }
        }
        .navigationTitle("Help Status")
        .navigationBarTitleDisplayMode(.inline)
        .alert(
            "Complete Request?",
            isPresented: $showCompletionAlert
        ) {
            
            Button("Cancel", role: .cancel) {
                
            }
            
            Button("Mark Completed") {
                
                controller.completeHelp(
                    for: request.id
                )
                
                dismiss()
            }
            
        } message: {
            
            Text(
                "Mark this request as completed once the help has been provided."
            )
        }
    }
    
    
    // MARK: - Status Icon
    
    private var statusIcon: String {
        
        switch request.status {
        case .open:
            return "clock.fill"

        case .inDiscussion:
            return "hands.sparkles.fill"

        case .confirmed:
            return "handshake.fill"

        case .inProgress:
            return "figure.walk"

        case .completed:
            return "checkmark.seal.fill"
        }
    }


    // MARK: - Time Ago

    private var timeAgo: String {

        let interval = Date().timeIntervalSince(request.createdAt)

        let minutes = Int(interval / 60)
        let hours = Int(interval / 3600)
        let days = Int(interval / 86400)

        if minutes < 1 {
            return "Just now"

        } else if minutes < 60 {
            return "\(minutes)m ago"

        } else if hours < 24 {
            return "\(hours)h ago"

        } else if days == 1 {
            return "Yesterday"

        } else if days < 7 {
            return "\(days)d ago"

        } else {

            let formatter = DateFormatter()
            formatter.dateStyle = .medium

            return formatter.string(from: request.createdAt)
        }
    }


    // MARK: - Timeline Steps

    private var timelineSteps: [
        (
            status: CommunityRequestStatus,
            title: String,
            subtitle: String,
            icon: String
        )
    ] {
        [
            (
                .open,
                "Request Posted",
                "Your request is visible to the community.",
                "checkmark.circle.fill"
            ),
            (
                .inDiscussion,
                "Helper Connected",
                "A community member is helping.",
                "hands.sparkles.fill"
            ),
            (
                .confirmed,
                "Help Confirmed",
                "The help agreement has been confirmed.",
                "handshake.fill"
            ),
            (
                .inProgress,
                "Help In Progress",
                "Help is currently underway.",
                "figure.walk"
            ),
            (
                .completed,
                "Completed",
                "The request has been successfully completed.",
                "checkmark.seal.fill"
            )
        ]
    }


    // MARK: - Status Rank

    private func statusRank(
        _ status: CommunityRequestStatus
    ) -> Int {

        switch status {
        case .open:
            return 0

        case .inDiscussion:
            return 1

        case .confirmed:
            return 2

        case .inProgress:
            return 3

        case .completed:
            return 4
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


// MARK: - Status Step Row

struct StatusStepRow: View {

    let title: String
    let subtitle: String
    let icon: String
    let isCompleted: Bool
    var isCurrent: Bool = false
    let isLast: Bool

    var body: some View {

        HStack(
            alignment: .top,
            spacing: 11
        ) {

            VStack(spacing: 0) {

                ZStack {

                    if isCurrent {

                        Circle()
                            .fill(
                                Color(
                                    red: 0.00,
                                    green: 0.55,
                                    blue: 0.45
                                )
                                .opacity(0.12)
                            )
                            .frame(
                                width: 26,
                                height: 26
                            )
                    }

                    Image(
                        systemName: icon
                    )
                    .font(.system(size: 15))
                    .foregroundStyle(
                        isCompleted
                            ? Color(
                                red: 0.00,
                                green: 0.55,
                                blue: 0.45
                            )
                            : .gray.opacity(0.5)
                    )
                }

                if !isLast {

                    Rectangle()
                        .fill(
                            isCompleted
                                ? Color(
                                    red: 0.00,
                                    green: 0.55,
                                    blue: 0.45
                                ).opacity(0.25)
                                : Color.gray.opacity(0.15)
                        )
                        .frame(
                            width: 1,
                            height: 31
                        )
                        .padding(.top, 4)
                }
            }
            .frame(width: 25)

            VStack(
                alignment: .leading,
                spacing: 3
            ) {

                Text(title)
                    .font(
                        .system(
                            size: 9,
                            weight: isCurrent ? .bold : .semibold
                        )
                    )
                    .foregroundStyle(
                        isCompleted
                            ? .black
                            : .gray
                    )

                Text(subtitle)
                    .font(.system(size: 7))
                    .foregroundStyle(.gray)
            }
            .padding(.top, 1)

            Spacer()

            if isCurrent {

                Text("Current")
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
                    .padding(.horizontal, 7)
                    .padding(.vertical, 4)
                    .background(
                        Color(
                            red: 0.00,
                            green: 0.55,
                            blue: 0.45
                        )
                        .opacity(0.10)
                    )
                    .clipShape(Capsule())
            }
        }
        .padding(.vertical, 7)
    }
}


// MARK: - Preview

#Preview {
    
    NavigationStack {
        
        HelpStatusView(
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
                status: .inDiscussion,
                helperName: "Juan Dela Cruz"
            )
        )
        .environment(BayanihanController())
    }
}
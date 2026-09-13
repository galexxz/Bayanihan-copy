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
                        
                        HStack(spacing: 9) {
                            
                            Image(
                                systemName: request.category.icon
                            )
                            .font(.system(size: 12))
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
                                        weight: .semibold
                                    )
                                )
                                .foregroundStyle(.black)
                                .lineLimit(2)
                            
                            Spacer()
                        }
                        
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
                        }
                        .font(.system(size: 7))
                        .foregroundStyle(.gray)
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
                        
                        StatusStepRow(
                            title: "Request Posted",
                            subtitle: "Your request is visible to the community.",
                            icon: "checkmark.circle.fill",
                            isCompleted: true,
                            isLast: request.status == .open
                        )
                        
                        if request.status != .open {
                            
                            StatusStepRow(
                                title: "Helper Connected",
                                subtitle: "A community member is helping.",
                                icon: "hands.sparkles.fill",
                                isCompleted: true,
                                isLast: request.status == .inDiscussion
                            )
                        }
                        
                        if request.status == .completed {
                            
                            StatusStepRow(
                                title: "Completed",
                                subtitle: "The request has been successfully completed.",
                                icon: "checkmark.seal.fill",
                                isCompleted: true,
                                isLast: true
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
    let isLast: Bool
    
    var body: some View {
        
        HStack(
            alignment: .top,
            spacing: 11
        ) {
            
            VStack(spacing: 0) {
                
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
                        : .gray
                )
                
                if !isLast {
                    
                    Rectangle()
                        .fill(
                            Color(
                                red: 0.00,
                                green: 0.55,
                                blue: 0.45
                            )
                            .opacity(0.25)
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
                            weight: .semibold
                        )
                    )
                    .foregroundStyle(.black)
                
                Text(subtitle)
                    .font(.system(size: 7))
                    .foregroundStyle(.gray)
            }
            .padding(.top, 1)
            
            Spacer()
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
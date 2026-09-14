import SwiftUI

struct NotificationsView: View {
    
    @Environment(BayanihanController.self) private var controller
    
    private var notifications: [CommunityNotification] {
        controller.notifications
    }

    private func associatedRequest(
        for notification: CommunityNotification
    ) -> CommunityRequest? {

        controller.requests.first { request in
            notification.message.contains(request.title)
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

            if notifications.isEmpty {

                EmptyNotificationsView()

            } else {

                ScrollView(showsIndicators: false) {

                    LazyVStack(
                        spacing: 10
                    ) {

                        ForEach(notifications) { notification in

                            let request = associatedRequest(
                                for: notification
                            )

                            if let request {

                                NavigationLink {

                                    RequestDetailsView(
                                        request: request
                                    )

                                } label: {

                                    NotificationRow(
                                        notification: notification
                                    )
                                }
                                .buttonStyle(.plain)

                            } else {

                                NotificationRow(
                                    notification: notification
                                )
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 15)
                    .padding(.bottom, 30)
                }
            }
        }
        .navigationTitle("Notifications")
        .navigationBarTitleDisplayMode(.inline)
    }
}


// MARK: - Notification Row

struct NotificationRow: View {
    
    let notification: CommunityNotification
    
    var body: some View {
        
        HStack(
            alignment: .top,
            spacing: 12
        ) {
            
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
                    systemName: notification.icon
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
                spacing: 5
            ) {
                
                Text(notification.title)
                    .font(
                        .system(
                            size: 11,
                            weight: .bold
                        )
                    )
                    .foregroundStyle(.black)
                
                Text(notification.message)
                    .font(.system(size: 9))
                    .foregroundStyle(.gray)
                    .lineSpacing(2)
                
                Text(timeAgo)
                .font(.system(size: 7))
                .foregroundStyle(.gray.opacity(0.8))
            }
            
            Spacer()
            
            if !notification.isRead {
                
                Circle()
                    .fill(
                        Color(
                            red: 0.00,
                            green: 0.55,
                            blue: 0.45
                        )
                    )
                    .frame(
                        width: 7,
                        height: 7
                    )
                    .padding(.top, 4)
            }
        }
        .padding(14)
        .background(
            notification.isRead
                ? Color.white
                : Color(
                    red: 0.00,
                    green: 0.55,
                    blue: 0.45
                ).opacity(0.06)
        )
        .clipShape(
            RoundedRectangle(
                cornerRadius: 14
            )
        )
    }
    
    
    // MARK: - Time Ago

    private var timeAgo: String {

        let interval = Date().timeIntervalSince(notification.date)

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

            return formatter.string(from: notification.date)
        }
    }
}


// MARK: - Empty Notifications

struct EmptyNotificationsView: View {
    
    var body: some View {
        
        VStack(spacing: 11) {
            
            Image(
                systemName: "bell.slash"
            )
            .font(.system(size: 32))
            .foregroundStyle(.gray.opacity(0.5))
            
            Text("No Notifications Yet")
                .font(
                    .system(
                        size: 14,
                        weight: .bold
                    )
                )
                .foregroundStyle(.black)

            Text(
                "Updates about your requests and help will appear here."
            )
            .font(.system(size: 9))
            .foregroundStyle(.gray)
            .multilineTextAlignment(.center)
            .padding(.horizontal, 35)
        }
        .frame(
            maxWidth: .infinity,
            maxHeight: .infinity
        )
    }
}


// MARK: - Preview

#Preview {
    
    NavigationStack {
        
        NotificationsView()
            .environment(BayanihanController())
    }
}
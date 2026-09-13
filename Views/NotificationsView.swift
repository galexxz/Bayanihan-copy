import SwiftUI

struct NotificationsView: View {
    
    @Environment(BayanihanController.self) private var controller
    
    private var notifications: [CommunityNotification] {
        controller.notifications
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
                            
                            NotificationRow(
                                notification: notification
                            )
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
                
                Text(
                    relativeDate(notification.date)
                )
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
    
    
    private func relativeDate(
        _ date: Date
    ) -> String {
        
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .short
        
        return formatter.localizedString(
            for: date,
            relativeTo: Date()
        )
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
            
            Text("No Notifications")
                .font(
                    .system(
                        size: 14,
                        weight: .bold
                    )
                )
                .foregroundStyle(.black)
            
            Text(
                "You'll see updates about your requests and community activity here."
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
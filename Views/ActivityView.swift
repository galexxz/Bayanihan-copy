import SwiftUI

struct ActivityView: View {

    @Environment(BayanihanController.self) private var controller

    @State private var selectedType: ActivityType = .all

    private var filteredActivities: [CommunityActivity] {

        controller.activities
            .filter {
                selectedType == .all || $0.type == selectedType
            }
            .sorted {
                $0.date > $1.date
            }
    }

    private func associatedRequest(
        for activity: CommunityActivity
    ) -> CommunityRequest? {

        controller.requests.first { request in
            activity.message.contains(request.title)
        }
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


                        // MARK: - Segmented Filter

                        Picker(
                            "",
                            selection: $selectedType
                        ) {

                            ForEach(
                                ActivityType.allCases
                            ) { type in

                                Text(type.rawValue)
                                    .tag(type)
                            }
                        }
                        .pickerStyle(.segmented)
                        .tint(
                            Color(
                                red: 0.00,
                                green: 0.55,
                                blue: 0.45
                            )
                        )
                        .padding(.top, 18)


                        // MARK: - Activity Feed

                        if filteredActivities.isEmpty {

                            EmptyActivityView(
                                selectedType: selectedType
                            )
                            .padding(.top, 40)

                        } else {

                            LazyVStack(spacing: 9) {

                                ForEach(
                                    filteredActivities
                                ) { activity in

                                    let request = associatedRequest(
                                        for: activity
                                    )

                                    if let request {

                                        NavigationLink {

                                            RequestDetailsView(
                                                request: request
                                            )

                                        } label: {

                                            ActivityRow(
                                                activity: activity,
                                                associatedRequest: request
                                            )
                                        }
                                        .buttonStyle(.plain)

                                    } else {

                                        ActivityRow(
                                            activity: activity,
                                            associatedRequest: nil
                                        )
                                    }
                                }
                            }
                            .padding(.top, 16)
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
}


// MARK: - Activity Row

struct ActivityRow: View {

    let activity: CommunityActivity
    let associatedRequest: CommunityRequest?

    var body: some View {

        HStack(
            alignment: .top,
            spacing: 11
        ) {

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
                    initials(activity.actorName)
                )
                .font(
                    .system(
                        size: 10,
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
                width: 38,
                height: 38
            )

            VStack(
                alignment: .leading,
                spacing: 4
            ) {

                HStack(spacing: 5) {

                    Text(activity.actorName)
                        .font(
                            .system(
                                size: 9,
                                weight: .bold
                            )
                        )
                        .foregroundStyle(.black)

                    if let associatedRequest {

                        Text("·")
                            .foregroundStyle(.gray)

                        Text(associatedRequest.category.rawValue)
                            .foregroundStyle(
                                Color(
                                    red: 0.00,
                                    green: 0.55,
                                    blue: 0.45
                                )
                            )
                    }
                }
                .font(.system(size: 7))

                Text(activity.message)
                    .font(.system(size: 8))
                    .foregroundStyle(.gray)
                    .lineLimit(2)

                Text(timeAgo)
                    .font(.system(size: 6))
                    .foregroundStyle(.gray.opacity(0.7))
            }

            Spacer()

            if let associatedRequest {

                MyRequestStatusBadge(
                    status: associatedRequest.status
                )
            }
        }
        .padding(12)
        .background(.white)
        .clipShape(
            RoundedRectangle(
                cornerRadius: 14
            )
        )
    }


    // MARK: - Time Ago

    private var timeAgo: String {

        let interval = Date().timeIntervalSince(activity.date)

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

            return formatter.string(from: activity.date)
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


// MARK: - Empty Activity

struct EmptyActivityView: View {

    let selectedType: ActivityType

    private var title: String {

        switch selectedType {
        case .all:
            return "No Activity Yet"

        case .volunteered:
            return "No Volunteering Yet"

        case .posted:
            return "No Requests Posted Yet"
        }
    }

    private var message: String {

        switch selectedType {
        case .all:
            return "Your requests and helping activities will appear here."

        case .volunteered:
            return "Requests you offer to help with will appear here."

        case .posted:
            return "Requests you post for your community will appear here."
        }
    }

    var body: some View {

        VStack(spacing: 10) {

            Image(
                systemName: "clock.arrow.circlepath"
            )
            .font(.system(size: 32))
            .foregroundStyle(
                .gray.opacity(0.45)
            )

            Text(title)
                .font(
                    .system(
                        size: 14,
                        weight: .bold
                    )
                )
                .foregroundStyle(.black)

            Text(message)
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

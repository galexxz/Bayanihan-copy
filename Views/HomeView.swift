import SwiftUI

struct HomeView: View {

    @Environment(BayanihanController.self) private var controller

    @State private var searchText = ""
    @State private var showOnlyUrgent = false

    private var openRequests: [CommunityRequest] {
        controller.requests.filter {
            $0.status == .open
        }
    }

    private var filteredOpenRequests: [CommunityRequest] {
        openRequests.filter { request in

            let matchesSearch =
                searchText.trimmingCharacters(
                    in: .whitespacesAndNewlines
                ).isEmpty ||
                request.title.localizedCaseInsensitiveContains(searchText) ||
                request.location.localizedCaseInsensitiveContains(searchText)

            let matchesUrgency =
                !showOnlyUrgent ||
                request.urgency == .urgent

            return matchesSearch && matchesUrgency
        }
    }

    private var activeHelpRequests: [CommunityRequest] {
        controller.requests.filter {
            $0.status == .inDiscussion ||
            $0.status == .confirmed ||
            $0.status == .inProgress
        }
    }

    private var unreadMessageCount: Int {
        controller.requests.filter {
            $0.status == .inDiscussion
        }.count
    }

    private var greeting: String {

        switch Calendar.current.component(.hour, from: Date()) {
        case 0..<12:
            return "Good morning,"

        case 12..<17:
            return "Good afternoon,"

        default:
            return "Good evening,"
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

                        HStack {

                            VStack(
                                alignment: .leading,
                                spacing: 4
                            ) {

                                Text(greeting)
                                    .font(.system(size: 9))
                                    .foregroundStyle(.gray)

                                Text(
                                    "\(controller.currentUser.name)! 👋"
                                )
                                .font(
                                    .system(
                                        size: 21,
                                        weight: .bold
                                    )
                                )
                                .foregroundStyle(.black)
                            }

                            Spacer()

                            HStack(spacing: 10) {

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

                                NavigationLink {

                                    MessagesView()

                                } label: {

                                    Image(
                                        systemName: "bubble.left.and.bubble.right.fill"
                                    )
                                    .font(.system(size: 14))
                                    .foregroundStyle(.black)
                                    .frame(
                                        width: 40,
                                        height: 40
                                    )
                                    .background(.white)
                                    .clipShape(Circle())
                                    .overlay(alignment: .topTrailing) {

                                        if unreadMessageCount > 0 {

                                            Text("\(unreadMessageCount)")
                                                .font(
                                                    .system(
                                                        size: 7,
                                                        weight: .bold
                                                    )
                                                )
                                                .foregroundStyle(.white)
                                                .frame(
                                                    minWidth: 15,
                                                    minHeight: 15
                                                )
                                                .background(
                                                    Color(
                                                        red: 0.00,
                                                        green: 0.55,
                                                        blue: 0.45
                                                    )
                                                )
                                                .clipShape(Circle())
                                        }
                                    }
                                }
                                .buttonStyle(.plain)

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
                                        initials(controller.currentUser.name)
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
                                    width: 40,
                                    height: 40
                                )
                            }
                        }
                        .padding(.top, 15)


                        // MARK: - Search

                        HStack(spacing: 8) {

                            Image(
                                systemName: "magnifyingglass"
                            )
                            .font(.system(size: 10))
                            .foregroundStyle(.gray)

                            TextField(
                                "Search requests...",
                                text: $searchText
                            )
                            .font(.system(size: 9))
                            .foregroundStyle(.black)

                            if !searchText.isEmpty {

                                Button {
                                    searchText = ""
                                } label: {

                                    Image(
                                        systemName: "xmark.circle.fill"
                                    )
                                    .font(.system(size: 10))
                                    .foregroundStyle(.gray)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .padding(.horizontal, 12)
                        .frame(height: 43)
                        .background(.white)
                        .clipShape(
                            RoundedRectangle(
                                cornerRadius: 11
                            )
                        )
                        .padding(.top, 17)


                        // MARK: - Filters

                        HStack(spacing: 7) {

                            UrgencyFilterChip(
                                title: "All",
                                isSelected: !showOnlyUrgent
                            ) {
                                showOnlyUrgent = false
                            }

                            UrgencyFilterChip(
                                title: "Urgent",
                                isSelected: showOnlyUrgent
                            ) {
                                showOnlyUrgent = true
                            }
                        }
                        .padding(.top, 10)


                        // MARK: - Welcome Card

                        HStack {

                            VStack(
                                alignment: .leading,
                                spacing: 7
                            ) {

                                Text(
                                    "Stronger Communities Through Bayanihan"
                                )
                                .font(
                                    .system(
                                        size: 15,
                                        weight: .bold
                                    )
                                )
                                .foregroundStyle(.white)
                                .fixedSize(
                                    horizontal: false,
                                    vertical: true
                                )

                                Text("Help · Support · Unite")
                                    .font(.system(size: 9))
                                    .foregroundStyle(.white.opacity(0.9))
                            }

                            Spacer()

                            Image(
                                systemName: "hands.sparkles.fill"
                            )
                            .font(.system(size: 34))
                            .foregroundStyle(.white.opacity(0.9))
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


                        // MARK: - Recent Requests

                        HStack {

                            Text("Recent Requests")
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
                                        filteredOpenRequests.prefix(3)
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
                                value: "\(controller.currentUser.requestsPosted)",
                                title: "Posted"
                            )

                            ImpactCard(
                                value: "\(controller.currentUser.requestsHelped)",
                                title: "Helped"
                            )

                            ImpactCard(
                                value: "\(controller.currentUser.communityPoints)",
                                title: "Points"
                            )
                        }
                        .padding(.top, 11)

                        Spacer(minLength: 35)
                    }
                    .padding(.horizontal, 20)
                }
            }
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
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

                Text(timeAgo)
                    .font(.system(size: 7))
                    .foregroundStyle(.gray.opacity(0.8))
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


    // MARK: - Time Ago

    private var timeAgo: String {

        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .short

        return formatter.localizedString(
            for: request.createdAt,
            relativeTo: Date()
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

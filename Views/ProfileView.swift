import SwiftUI

struct ProfileView: View {

    @Environment(BayanihanController.self) private var controller

    @State private var showSignOutConfirmation = false

    private var myRequestsCount: Int {
        controller.requests.filter {
            $0.requesterUsername == controller.currentUser.username
        }.count
    }

    private var helpedCount: Int {
        controller.requests.filter {
            $0.helperName == controller.currentUser.name
        }.count
    }

    private var unreadMessageCount: Int {
        controller.requests.filter {
            $0.status == .inDiscussion
        }.count
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

                    VStack(spacing: 0) {

                        // MARK: - Cover & Avatar

                        ZStack(alignment: .bottom) {

                            RoundedRectangle(
                                cornerRadius: 20
                            )
                            .fill(
                                Color(
                                    red: 0.00,
                                    green: 0.55,
                                    blue: 0.45
                                )
                            )
                            .frame(height: 85)

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
                                        size: 25,
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
                                width: 82,
                                height: 82
                            )
                            .overlay(
                                Circle()
                                    .stroke(
                                        Color(
                                            red: 0.95,
                                            green: 0.98,
                                            blue: 0.97
                                        ),
                                        lineWidth: 4
                                    )
                            )
                            .offset(y: 41)
                        }
                        .padding(.top, 10)

                        Text(controller.currentUser.name)
                            .font(
                                .system(
                                    size: 18,
                                    weight: .bold
                                )
                            )
                            .foregroundStyle(.black)
                            .padding(.top, 49)

                        Text(controller.currentUser.username)
                            .font(.system(size: 9))
                            .foregroundStyle(.gray)
                            .padding(.top, 3)

                        HStack(spacing: 4) {

                            Image(
                                systemName: "mappin.and.ellipse"
                            )
                            .font(.system(size: 8))

                            Text(controller.currentUser.location)
                                .font(.system(size: 8))
                        }
                        .foregroundStyle(.gray)
                        .padding(.top, 4)


                        // MARK: - Stats

                        HStack(spacing: 9) {

                            ProfileStatCard(
                                value: "\(myRequestsCount)",
                                title: "Posted"
                            )

                            ProfileStatCard(
                                value: "\(helpedCount)",
                                title: "Helped"
                            )

                            ProfileStatCard(
                                value: "\(controller.currentUser.communityPoints)",
                                title: "Points"
                            )
                        }
                        .padding(.top, 20)


                        // MARK: - Menu

                        VStack(spacing: 9) {

                            NavigationLink {

                                MyRequestsView()

                            } label: {

                                ProfileMenuRow(
                                    icon: "hand.raised.fill",
                                    title: "My Requests",
                                    subtitle: "View requests you have posted"
                                )
                            }
                            .buttonStyle(.plain)


                            NavigationLink {

                                MyRequestsView(
                                    showHelped: true
                                )

                            } label: {

                                ProfileMenuRow(
                                    icon: "hands.sparkles.fill",
                                    title: "Helped Requests",
                                    subtitle: "View requests you're helping with"
                                )
                            }
                            .buttonStyle(.plain)


                            NavigationLink {

                                MessagesView()

                            } label: {

                                ProfileMenuRow(
                                    icon: "bubble.left.and.bubble.right.fill",
                                    title: "Messages",
                                    subtitle: "View your conversations",
                                    badgeCount: unreadMessageCount
                                )
                            }
                            .buttonStyle(.plain)


                            NavigationLink {

                                EditProfileView()

                            } label: {

                                ProfileMenuRow(
                                    icon: "person.crop.circle",
                                    title: "Edit Profile",
                                    subtitle: "Update your profile information"
                                )
                            }
                            .buttonStyle(.plain)


                            NavigationLink {

                                SettingsView()

                            } label: {

                                ProfileMenuRow(
                                    icon: "gearshape.fill",
                                    title: "Settings",
                                    subtitle: "Manage your app preferences"
                                )
                            }
                            .buttonStyle(.plain)
                        }
                        .padding(.top, 22)


                        // MARK: - Log Out

                        Button {
                            showSignOutConfirmation = true
                        } label: {

                            HStack {

                                Image(
                                    systemName: "rectangle.portrait.and.arrow.right"
                                )
                                .font(.system(size: 12))

                                Text("Log Out")
                                    .font(
                                        .system(
                                            size: 10,
                                            weight: .semibold
                                        )
                                    )

                                Spacer()
                            }
                            .foregroundStyle(.red)
                            .padding(.horizontal, 15)
                            .frame(height: 50)
                            .background(.white)
                            .clipShape(
                                RoundedRectangle(
                                    cornerRadius: 13
                                )
                            )
                        }
                        .buttonStyle(.plain)
                        .padding(.top, 12)


                        // MARK: - Community Message

                        VStack(spacing: 7) {

                            Image(
                                systemName: "hands.sparkles.fill"
                            )
                            .font(.system(size: 17))
                            .foregroundStyle(
                                Color(
                                    red: 0.00,
                                    green: 0.55,
                                    blue: 0.45
                                )
                            )

                            Text(
                                "Together, we make our community stronger."
                            )
                            .font(
                                .system(
                                    size: 9,
                                    weight: .semibold
                                )
                            )
                            .foregroundStyle(.black)
                            .multilineTextAlignment(.center)

                            Text(
                                "Every small act of help matters."
                            )
                            .font(.system(size: 8))
                            .foregroundStyle(.gray)
                        }
                        .frame(
                            maxWidth: .infinity
                        )
                        .padding(.vertical, 17)
                        .padding(.horizontal, 15)
                        .background(
                            Color(
                                red: 0.00,
                                green: 0.55,
                                blue: 0.45
                            )
                            .opacity(0.07)
                        )
                        .clipShape(
                            RoundedRectangle(
                                cornerRadius: 14
                            )
                        )
                        .padding(.top, 22)

                        Spacer(minLength: 30)
                    }
                    .padding(.horizontal, 20)
                }
            }
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.inline)
            .alert(
                "Sign Out?",
                isPresented: $showSignOutConfirmation
            ) {

                Button("Cancel", role: .cancel) {

                }

                Button("Sign Out", role: .destructive) {
                    controller.logout()
                }

            } message: {

                Text(
                    "Are you sure you want to sign out of Bayanihan?"
                )
            }
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


// MARK: - Profile Stat Card

struct ProfileStatCard: View {

    let value: String
    let title: String

    var body: some View {

        VStack(spacing: 4) {

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
                .font(.system(size: 7))
                .foregroundStyle(.gray)
        }
        .frame(
            maxWidth: .infinity
        )
        .frame(height: 62)
        .background(.white)
        .clipShape(
            RoundedRectangle(
                cornerRadius: 13
            )
        )
    }
}


// MARK: - Profile Menu Row

struct ProfileMenuRow: View {

    let icon: String
    let title: String
    let subtitle: String
    var badgeCount: Int = 0

    var body: some View {

        HStack(spacing: 11) {

            ZStack {

                RoundedRectangle(
                    cornerRadius: 9
                )
                .fill(
                    Color(
                        red: 0.84,
                        green: 0.93,
                        blue: 0.90
                    )
                )

                Image(systemName: icon)
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
                spacing: 3
            ) {

                Text(title)
                    .font(
                        .system(
                            size: 10,
                            weight: .bold
                        )
                    )
                    .foregroundStyle(.black)

                Text(subtitle)
                    .font(.system(size: 7))
                    .foregroundStyle(.gray)
            }

            Spacer()

            if badgeCount > 0 {

                Text("\(badgeCount)")
                    .font(
                        .system(
                            size: 7,
                            weight: .bold
                        )
                    )
                    .foregroundStyle(.white)
                    .frame(
                        minWidth: 16,
                        minHeight: 16
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

            Image(
                systemName: "chevron.right"
            )
            .font(
                .system(
                    size: 9,
                    weight: .semibold
                )
            )
            .foregroundStyle(.gray.opacity(0.6))
        }
        .padding(.horizontal, 12)
        .frame(height: 62)
        .background(.white)
        .clipShape(
            RoundedRectangle(
                cornerRadius: 14
            )
        )
    }
}


// MARK: - Preview

#Preview {

    ProfileView()
        .environment(BayanihanController())
}

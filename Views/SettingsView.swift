import SwiftUI

struct SettingsView: View {

    @Environment(BayanihanController.self) private var controller

    @State private var isDarkModeEnabled = false
    @State private var showSignOutConfirmation = false
    @State private var showAboutSheet = false

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

                    // MARK: - General

                    SettingsSectionTitle(
                        title: "General"
                    )
                    .padding(.top, 15)

                    VStack(spacing: 0) {

                        NavigationLink {

                            NotificationsView()

                        } label: {

                            SettingsNavigationRow(
                                title: "Notifications",
                                icon: "bell.fill"
                            )
                        }
                        .buttonStyle(.plain)

                        Divider()
                            .padding(.leading, 52)

                        SettingsToggleRow(
                            title: "Dark Mode",
                            subtitle: "Switch to a darker appearance",
                            icon: "moon.fill",
                            isOn: $isDarkModeEnabled
                        )

                        Divider()
                            .padding(.leading, 52)

                        SettingsInfoRow(
                            title: "Language",
                            value: "English",
                            icon: "globe"
                        )
                    }
                    .background(.white)
                    .clipShape(
                        RoundedRectangle(
                            cornerRadius: 15
                        )
                    )
                    .padding(.top, 10)


                    // MARK: - Account

                    SettingsSectionTitle(
                        title: "Account"
                    )
                    .padding(.top, 23)

                    VStack(spacing: 0) {

                        Button {
                            // Privacy & Security will be added later.
                        } label: {

                            SettingsNavigationRow(
                                title: "Privacy & Security",
                                icon: "lock.shield.fill"
                            )
                        }
                        .buttonStyle(.plain)

                        Divider()
                            .padding(.leading, 52)

                        Button {
                            // Help & Support will be added later.
                        } label: {

                            SettingsNavigationRow(
                                title: "Help & Support",
                                icon: "questionmark.circle.fill"
                            )
                        }
                        .buttonStyle(.plain)

                        Divider()
                            .padding(.leading, 52)

                        Button {
                            showAboutSheet = true
                        } label: {

                            SettingsNavigationRow(
                                title: "About Bayanihan",
                                icon: "info.circle.fill"
                            )
                        }
                        .buttonStyle(.plain)
                    }
                    .background(.white)
                    .clipShape(
                        RoundedRectangle(
                            cornerRadius: 15
                        )
                    )
                    .padding(.top, 10)


                    // MARK: - Sign Out

                    Button {
                        showSignOutConfirmation = true
                    } label: {

                        HStack {

                            Image(
                                systemName: "rectangle.portrait.and.arrow.right"
                            )
                            .font(.system(size: 12))

                            Text("Sign Out")
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
                    .padding(.top, 23)

                    Spacer(minLength: 30)
                }
                .padding(.horizontal, 20)
            }
        }
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showAboutSheet) {
            AboutBayanihanView()
        }
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


// MARK: - Section Title

struct SettingsSectionTitle: View {

    let title: String

    var body: some View {

        Text(title)
            .font(
                .system(
                    size: 13,
                    weight: .bold
                )
            )
            .foregroundStyle(.black)
    }
}


// MARK: - Information Row

struct SettingsInfoRow: View {

    let title: String
    let value: String
    let icon: String

    var body: some View {

        HStack(spacing: 11) {

            Image(
                systemName: icon
            )
            .font(.system(size: 11))
            .foregroundStyle(
                Color(
                    red: 0.00,
                    green: 0.55,
                    blue: 0.45
                )
            )
            .frame(
                width: 31,
                height: 31
            )
            .background(
                Color(
                    red: 0.00,
                    green: 0.55,
                    blue: 0.45
                )
                .opacity(0.10)
            )
            .clipShape(
                RoundedRectangle(
                    cornerRadius: 8
                )
            )

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

                Text(value)
                    .font(.system(size: 8))
                    .foregroundStyle(.gray)
            }

            Spacer()
        }
        .padding(.horizontal, 13)
        .frame(height: 58)
    }
}


// MARK: - Toggle Row

struct SettingsToggleRow: View {

    let title: String
    let subtitle: String
    let icon: String

    @Binding var isOn: Bool

    var body: some View {

        HStack(spacing: 11) {

            Image(
                systemName: icon
            )
            .font(.system(size: 11))
            .foregroundStyle(
                Color(
                    red: 0.00,
                    green: 0.55,
                    blue: 0.45
                )
            )
            .frame(
                width: 31,
                height: 31
            )
            .background(
                Color(
                    red: 0.00,
                    green: 0.55,
                    blue: 0.45
                )
                .opacity(0.10)
            )
            .clipShape(
                RoundedRectangle(
                    cornerRadius: 8
                )
            )

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

            Spacer()

            Toggle(
                "",
                isOn: $isOn
            )
            .labelsHidden()
            .tint(
                Color(
                    red: 0.00,
                    green: 0.55,
                    blue: 0.45
                )
            )
        }
        .padding(.horizontal, 13)
        .frame(height: 65)
    }
}


// MARK: - Navigation Row

struct SettingsNavigationRow: View {

    let title: String
    let icon: String

    var body: some View {

        HStack(spacing: 11) {

            Image(
                systemName: icon
            )
            .font(.system(size: 11))
            .foregroundStyle(
                Color(
                    red: 0.00,
                    green: 0.55,
                    blue: 0.45
                )
            )
            .frame(
                width: 31,
                height: 31
            )
            .background(
                Color(
                    red: 0.00,
                    green: 0.55,
                    blue: 0.45
                )
                .opacity(0.10)
            )
            .clipShape(
                RoundedRectangle(
                    cornerRadius: 8
                )
            )

            Text(title)
                .font(
                    .system(
                        size: 9,
                        weight: .semibold
                    )
                )
                .foregroundStyle(.black)

            Spacer()

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
        .padding(.horizontal, 13)
        .frame(height: 58)
    }
}


// MARK: - About Bayanihan

struct AboutBayanihanView: View {

    @Environment(\.dismiss) private var dismiss

    var body: some View {

        NavigationStack {

            ZStack {

                Color(
                    red: 0.95,
                    green: 0.98,
                    blue: 0.97
                )
                .ignoresSafeArea()

                VStack(spacing: 10) {

                    Image(
                        systemName: "heart.fill"
                    )
                    .font(.system(size: 38))
                    .foregroundStyle(
                        Color(
                            red: 0.00,
                            green: 0.55,
                            blue: 0.45
                        )
                    )
                    .padding(.top, 40)

                    Text("Bayanihan")
                        .font(
                            .system(
                                size: 20,
                                weight: .bold
                            )
                        )
                        .foregroundStyle(.black)

                    Text("Community Assistance Platform")
                        .font(.system(size: 10))
                        .foregroundStyle(.gray)

                    Text("Version 1.0.0")
                        .font(.system(size: 9))
                        .foregroundStyle(.gray)
                        .padding(.top, 4)

                    Text(
                        "Bayanihan connects neighbors who need help with community members willing to lend a hand — together, we make our community stronger."
                    )
                    .font(.system(size: 9))
                    .foregroundStyle(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 35)
                    .padding(.top, 14)

                    Spacer()
                }
            }
            .navigationTitle("About")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {

                ToolbarItem(placement: .confirmationAction) {

                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}


// MARK: - Preview

#Preview {

    NavigationStack {

        SettingsView()
            .environment(BayanihanController())
    }
}

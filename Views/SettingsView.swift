import SwiftUI

struct SettingsView: View {
    
    @Environment(BayanihanController.self) private var controller
    
    @State private var notificationsEnabled = true
    @State private var locationEnabled = true
    @State private var showSignOutConfirmation = false
    
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
                        
                    // MARK: - Account Information
                        
                    SettingsSectionTitle(
                        title: "Account"
                    )
                    .padding(.top, 15)
                        
                    VStack(spacing: 0) {
                            
                        SettingsInfoRow(
                            title: "Name",
                            value: controller.currentUser.name,
                            icon: "person.fill"
                        )
                            
                        Divider()
                            .padding(.leading, 52)
                            
                        SettingsInfoRow(
                            title: "Username",
                            value: controller.currentUser.username,
                            icon: "at"
                        )
                            
                        Divider()
                            .padding(.leading, 52)
                            
                        SettingsInfoRow(
                            title: "Location",
                            value: controller.currentUser.location,
                            icon: "mappin.and.ellipse"
                        )
                    }
                    .background(.white)
                    .clipShape(
                        RoundedRectangle(
                            cornerRadius: 15
                        )
                    )
                    .padding(.top, 10)
                    
                    
                    // MARK: - Preferences
                        
                    SettingsSectionTitle(
                        title: "Preferences"
                    )
                    .padding(.top, 23)
                        
                    VStack(spacing: 0) {
                            
                        SettingsToggleRow(
                            title: "Notifications",
                            subtitle: "Receive updates about your requests",
                            icon: "bell.fill",
                            isOn: $notificationsEnabled
                        )
                            
                        Divider()
                            .padding(.leading, 52)
                            
                        SettingsToggleRow(
                            title: "Location Services",
                            subtitle: "Help show requests near you",
                            icon: "location.fill",
                            isOn: $locationEnabled
                        )
                    }
                    .background(.white)
                    .clipShape(
                        RoundedRectangle(
                            cornerRadius: 15
                        )
                    )
                    .padding(.top, 10)
                    
                    
                    // MARK: - About
                        
                    SettingsSectionTitle(
                        title: "About"
                    )
                    .padding(.top, 23)
                        
                    VStack(spacing: 0) {
                            
                        SettingsInfoRow(
                            title: "App Version",
                            value: "1.0.0",
                            icon: "info.circle.fill"
                        )
                            
                        Divider()
                            .padding(.leading, 52)
                            
                        SettingsInfoRow(
                            title: "Community",
                            value: "Bayanihan",
                            icon: "person.3.fill"
                        )
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


// MARK: - Preview

#Preview {
    
    NavigationStack {
        
        SettingsView()
            .environment(BayanihanController())
    }
}
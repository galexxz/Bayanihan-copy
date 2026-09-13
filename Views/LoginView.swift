import SwiftUI

struct LoginView: View {
    
    @Environment(BayanihanController.self) private var controller

    @State private var email = ""
    @State private var password = ""
    @State private var rememberMe = false
    @State private var showPassword = false
    
    var body: some View {
        ZStack {
            Color(
                red: 0.95,
                green: 0.98,
                blue: 0.97
            )
            .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 0) {
                    
                    // MARK: - Header
                    
                    VStack(spacing: 8) {
                        Text("Welcome Back")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundStyle(.black)
                        
                        Text("Sign in to continue helping your community.")
                            .font(.system(size: 13))
                            .foregroundStyle(.gray)
                            .multilineTextAlignment(.center)
                    }
                    .padding(.top, 45)
                    
                    // MARK: - Login Form
                    
                    VStack(alignment: .leading, spacing: 18) {
                        
                        // Email
                        VStack(alignment: .leading, spacing: 7) {
                            Text("Email or Username")
                                .font(.system(size: 13, weight: .semibold))
                                .foregroundStyle(.black)
                            
                            TextField(
                                "Enter your email or username",
                                text: $email
                            )
                            .textInputAutocapitalization(.never)
                            .keyboardType(.emailAddress)
                            .padding(.horizontal, 14)
                            .frame(height: 48)
                            .background(.white)
                            .clipShape(
                                RoundedRectangle(cornerRadius: 12)
                            )
                            .overlay {
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(
                                        Color.gray.opacity(0.2),
                                        lineWidth: 1
                                    )
                            }
                        }
                        
                        // Password
                        VStack(alignment: .leading, spacing: 7) {
                            Text("Password")
                                .font(.system(size: 13, weight: .semibold))
                                .foregroundStyle(.black)
                            
                            HStack {
                                if showPassword {
                                    TextField(
                                        "Enter your password",
                                        text: $password
                                    )
                                } else {
                                    SecureField(
                                        "Enter your password",
                                        text: $password
                                    )
                                }
                                
                                Button {
                                    showPassword.toggle()
                                } label: {
                                    Image(
                                        systemName: showPassword
                                        ? "eye.slash"
                                        : "eye"
                                    )
                                    .foregroundStyle(.gray)
                                }
                            }
                            .padding(.horizontal, 14)
                            .frame(height: 48)
                            .background(.white)
                            .clipShape(
                                RoundedRectangle(cornerRadius: 12)
                            )
                            .overlay {
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(
                                        Color.gray.opacity(0.2),
                                        lineWidth: 1
                                    )
                            }
                        }
                        
                        // Remember Me + Forgot Password
                        HStack {
                            Button {
                                rememberMe.toggle()
                            } label: {
                                HStack(spacing: 7) {
                                    Image(
                                        systemName: rememberMe
                                        ? "checkmark.square.fill"
                                        : "square"
                                    )
                                    .foregroundStyle(
                                        Color(
                                            red: 0.00,
                                            green: 0.55,
                                            blue: 0.45
                                        )
                                    )
                                    
                                    Text("Remember Me")
                                        .font(.system(size: 12))
                                        .foregroundStyle(.gray)
                                }
                            }
                            
                            Spacer()
                            
                            Button("Forgot Password?") {
                                // Forgot password will be added later.
                            }
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundStyle(
                                Color(
                                    red: 0.00,
                                    green: 0.55,
                                    blue: 0.45
                                )
                            )
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 35)
                    
                    // MARK: - Log In Button
                    
                    Button {
                        // Demo login: any credentials proceed into the app.
                        controller.isLoggedIn = true
                    } label: {
                        Text("Log In")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 48)
                            .background(
                                Color(
                                    red: 0.00,
                                    green: 0.55,
                                    blue: 0.45
                                )
                            )
                            .clipShape(
                                RoundedRectangle(cornerRadius: 12)
                            )
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 25)
                    
                    // MARK: - Divider
                    
                    HStack(spacing: 12) {
                        Rectangle()
                            .fill(Color.gray.opacity(0.2))
                            .frame(height: 1)
                        
                        Text("OR")
                            .font(.system(size: 10, weight: .semibold))
                            .foregroundStyle(.gray)
                        
                        Rectangle()
                            .fill(Color.gray.opacity(0.2))
                            .frame(height: 1)
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 25)
                    
                    // MARK: - Apple Login
                    
                    Button {
                        // Apple Sign In will be added later.
                    } label: {
                        HStack(spacing: 8) {
                            Image(systemName: "apple.logo")
                            
                            Text("Continue with Apple")
                                .font(.system(size: 13, weight: .semibold))
                        }
                        .foregroundStyle(.black)
                        .frame(maxWidth: .infinity)
                        .frame(height: 48)
                        .background(.white)
                        .clipShape(
                            RoundedRectangle(cornerRadius: 12)
                        )
                        .overlay {
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(
                                    Color.gray.opacity(0.2),
                                    lineWidth: 1
                                )
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 18)
                    
                    // MARK: - Sign Up
                    
                    HStack(spacing: 4) {
                        Text("Don't have an account?")
                            .foregroundStyle(.gray)
                        
                        NavigationLink {
                            SignUpView()
                        } label: {
                            Text("Sign Up")
                                .fontWeight(.bold)
                                .foregroundStyle(
                                    Color(
                                        red: 0.00,
                                        green: 0.55,
                                        blue: 0.45
                                    )
                                )
                        }
                    }
                    .font(.system(size: 12))
                    .padding(.top, 25)
                    .padding(.bottom, 25)
                }
            }
        }
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(.hidden, for: .navigationBar)
        .navigationDestination(
            isPresented: Binding(
                get: { controller.isLoggedIn },
                set: { controller.isLoggedIn = $0 }
            )
        ) {
            AppTabBarView()
        }
    }
}

#Preview {
    NavigationStack {
        LoginView()
            .environment(BayanihanController())
    }
}
import SwiftUI

struct SignUpView: View {

    @Environment(\.dismiss) private var dismiss

    @State private var fullName = ""
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var location = ""
    
    @State private var showPassword = false
    @State private var showConfirmPassword = false
    @State private var agreeToTerms = false
    
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

                    // MARK: - Branding

                    ZStack {
                        RoundedRectangle(cornerRadius: 16)
                            .fill(
                                Color(
                                    red: 0.00,
                                    green: 0.55,
                                    blue: 0.45
                                )
                            )

                        Image(systemName: "person.2.fill")
                            .font(.system(size: 22, weight: .bold))
                            .foregroundStyle(.white)
                    }
                    .frame(width: 56, height: 56)
                    .padding(.top, 24)

                    // MARK: - Header

                    VStack(spacing: 8) {
                        Text("Create an Account")
                            .font(.system(size: 27, weight: .bold))
                            .foregroundStyle(.black)

                        Text("Join Bayanihan and start helping your community.")
                            .font(.system(size: 13))
                            .foregroundStyle(.gray)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 25)
                    }
                    .padding(.top, 16)
                    
                    // MARK: - Form
                    
                    VStack(alignment: .leading, spacing: 16) {
                        
                        // Full Name
                        FormField(
                            title: "Full Name",
                            placeholder: "Enter your full name",
                            text: $fullName
                        )
                        
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
                                        "Create a password",
                                        text: $password
                                    )
                                } else {
                                    SecureField(
                                        "Create a password",
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
                        
                        // Confirm Password
                        VStack(alignment: .leading, spacing: 7) {
                            Text("Confirm Password")
                                .font(.system(size: 13, weight: .semibold))
                                .foregroundStyle(.black)
                            
                            HStack {
                                if showConfirmPassword {
                                    TextField(
                                        "Re-enter your password",
                                        text: $confirmPassword
                                    )
                                } else {
                                    SecureField(
                                        "Re-enter your password",
                                        text: $confirmPassword
                                    )
                                }
                                
                                Button {
                                    showConfirmPassword.toggle()
                                } label: {
                                    Image(
                                        systemName: showConfirmPassword
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
                        
                        // Location
                        FormField(
                            title: "Location",
                            placeholder: "Enter your barangay or area",
                            text: $location
                        )
                        
                        // Terms
                        Button {
                            agreeToTerms.toggle()
                        } label: {
                            HStack(
                                alignment: .top,
                                spacing: 8
                            ) {
                                Image(
                                    systemName: agreeToTerms
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
                                
                                Text(
                                    "I agree to the Bayanihan Terms and Privacy Policy."
                                )
                                .font(.system(size: 11))
                                .foregroundStyle(.gray)
                                .multilineTextAlignment(.leading)
                            }
                        }
                        .padding(.top, 3)
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 30)
                    
                    // MARK: - Sign Up Button
                    
                    Button {
                        // Account creation will be connected later.
                    } label: {
                        Text("Create Account")
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
                    .padding(.top, 24)
                    
                    // MARK: - Login Link
                    
                    HStack(spacing: 4) {
                        Text("Already have an account?")
                            .foregroundStyle(.gray)
                        
                        Button("Log In") {
                            dismiss()
                        }
                        .fontWeight(.bold)
                        .foregroundStyle(
                            Color(
                                red: 0.00,
                                green: 0.55,
                                blue: 0.45
                            )
                        )
                    }
                    .font(.system(size: 12))
                    .padding(.top, 20)

                    // MARK: - Footer

                    Text("Bayanihan · Community Assistance Platform")
                        .font(.system(size: 9, weight: .medium))
                        .foregroundStyle(
                            Color(
                                red: 0.35,
                                green: 0.68,
                                blue: 0.62
                            )
                        )
                        .padding(.top, 18)
                        .padding(.bottom, 20)
                }
            }
        }
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(.hidden, for: .navigationBar)
    }
}


// MARK: - Reusable Form Field

struct FormField: View {
    
    let title: String
    let placeholder: String
    @Binding var text: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 7) {
            
            Text(title)
                .font(.system(size: 13, weight: .semibold))
                .foregroundStyle(.black)
            
            TextField(placeholder, text: $text)
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
    }
}


#Preview {
    NavigationStack {
        SignUpView()
    }
}
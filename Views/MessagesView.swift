import SwiftUI

struct MessagesView: View {
    
    @Environment(BayanihanController.self) private var controller
    
    private var messageRequests: [CommunityRequest] {
        controller.requests.filter { request in
            request.helperName != nil &&
            (
                request.requesterUsername == controller.currentUser.username ||
                request.helperName == controller.currentUser.name
            )
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
                
                if messageRequests.isEmpty {
                    
                    EmptyMessagesView()
                    
                } else {
                    
                    ScrollView(showsIndicators: false) {
                        
                        VStack(
                            alignment: .leading,
                            spacing: 0
                        ) {
                            
                            Text("Your Conversations")
                                .font(
                                    .system(
                                        size: 22,
                                        weight: .bold
                                    )
                                )
                                .foregroundStyle(.black)
                                .padding(.top, 15)
                            
                            Text(
                                "Stay connected while helping your community."
                            )
                            .font(.system(size: 9))
                            .foregroundStyle(.gray)
                            .padding(.top, 4)
                            
                            LazyVStack(
                                spacing: 9
                            ) {
                                
                                ForEach(messageRequests) { request in
                                    
                                    NavigationLink {
                                        
                                        ChatView(
                                            request: request
                                        )
                                        
                                    } label: {
                                        
                                        MessageConversationRow(
                                            request: request,
                                            currentUserName:
                                                controller.currentUser.name,
                                            currentUsername:
                                                controller.currentUser.username
                                        )
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                            .padding(.top, 18)
                            
                            Spacer(minLength: 30)
                        }
                        .padding(.horizontal, 20)
                    }
                }
            }
            .navigationTitle("Messages")
            .navigationBarTitleDisplayMode(.inline)
    }
}


// MARK: - Conversation Row

struct MessageConversationRow: View {
    
    let request: CommunityRequest
    let currentUserName: String
    let currentUsername: String
    
    private var otherPersonName: String {
        
        if request.requesterUsername == currentUsername {
            return request.helperName ?? "Community Helper"
        }
        
        return request.requesterName
    }
    
    private var conversationSubtitle: String {
        
        if request.status == .completed {
            return "Request completed"
        }
        
        return request.title
    }
    
    var body: some View {
        
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
                    initials(otherPersonName)
                )
                .font(
                    .system(
                        size: 12,
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
                width: 45,
                height: 45
            )
            
            VStack(
                alignment: .leading,
                spacing: 4
            ) {
                
                Text(otherPersonName)
                    .font(
                        .system(
                            size: 10,
                            weight: .bold
                        )
                    )
                    .foregroundStyle(.black)
                
                Text(conversationSubtitle)
                    .font(.system(size: 8))
                    .foregroundStyle(.gray)
                    .lineLimit(1)
                
                HStack(spacing: 5) {
                    
                    Image(
                        systemName: request.category.icon
                    )
                    .font(.system(size: 7))
                    
                    Text(request.category.rawValue)
                        .font(.system(size: 7))
                }
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
            .font(
                .system(
                    size: 9,
                    weight: .semibold
                )
            )
            .foregroundStyle(.gray.opacity(0.6))
        }
        .padding(.horizontal, 13)
        .frame(height: 73)
        .background(.white)
        .clipShape(
            RoundedRectangle(
                cornerRadius: 14
            )
        )
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


// MARK: - Empty Messages

struct EmptyMessagesView: View {
    
    var body: some View {
        
        VStack(spacing: 10) {
            
            Image(
                systemName: "bubble.left.and.bubble.right"
            )
            .font(.system(size: 34))
            .foregroundStyle(
                .gray.opacity(0.45)
            )
            
            Text("No Messages Yet")
                .font(
                    .system(
                        size: 14,
                        weight: .bold
                    )
                )
                .foregroundStyle(.black)
            
            Text(
                "Your conversations with community members will appear here."
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
    
    MessagesView()
        .environment(BayanihanController())
}
import SwiftUI

struct ChatView: View {
    
    @Environment(BayanihanController.self) private var controller
    
    let request: CommunityRequest
    
    @State private var messageText = ""
    
    private var messages: [ChatMessage] {
        controller.messages(for: request.id)
    }
    
    var body: some View {
        
        VStack(spacing: 0) {
            
            // MARK: - Request Header
            
            VStack(
                alignment: .leading,
                spacing: 5
            ) {
                
                HStack {
                    
                    VStack(
                        alignment: .leading,
                        spacing: 3
                    ) {
                        
                        Text(request.title)
                            .font(
                                .system(
                                    size: 11,
                                    weight: .bold
                                )
                            )
                            .foregroundStyle(.black)
                            .lineLimit(1)
                        
                        Text(
                            request.requesterName
                        )
                        .font(.system(size: 8))
                        .foregroundStyle(.gray)
                    }
                    
                    Spacer()
                    
                    Text(
                        request.status.rawValue
                    )
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
                    .padding(
                        .horizontal,
                        8
                    )
                    .padding(
                        .vertical,
                        5
                    )
                    .background(
                        Color(
                            red: 0.00,
                            green: 0.55,
                            blue: 0.45
                        )
                        .opacity(0.10)
                    )
                    .clipShape(Capsule())
                }
            }
            .padding(.horizontal, 15)
            .padding(.vertical, 12)
            .background(.white)
            
            
            Divider()
            
            
            // MARK: - Messages
            
            ZStack {
                
                Color(
                    red: 0.95,
                    green: 0.98,
                    blue: 0.97
                )
                
                if messages.isEmpty {
                    
                    VStack(spacing: 9) {
                        
                        Image(
                            systemName: "bubble.left.and.bubble.right"
                        )
                        .font(.system(size: 28))
                        .foregroundStyle(
                            .gray.opacity(0.45)
                        )
                        
                        Text("Start a Conversation")
                            .font(
                                .system(
                                    size: 13,
                                    weight: .bold
                                )
                            )
                            .foregroundStyle(.black)
                        
                        Text(
                            "Send a message to coordinate the help request."
                        )
                        .font(.system(size: 8))
                        .foregroundStyle(.gray)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                    }
                    
                } else {
                    
                    ScrollViewReader { proxy in
                        
                        ScrollView(
                            showsIndicators: false
                        ) {
                            
                            LazyVStack(
                                spacing: 10
                            ) {
                                
                                ForEach(messages) { message in
                                    
                                    ChatBubble(
                                        message: message,
                                        isCurrentUser:
                                            message.senderUsername ==
                                            controller.currentUser.username
                                    )
                                    .id(message.id)
                                }
                            }
                            .padding(.horizontal, 15)
                            .padding(.vertical, 15)
                        }
                        .onChange(
                            of: messages.count
                        ) {
                            if let lastMessage = messages.last {
                                
                                withAnimation {
                                    proxy.scrollTo(
                                        lastMessage.id,
                                        anchor: .bottom
                                    )
                                }
                            }
                        }
                    }
                }
            }
            
            
            // MARK: - Message Composer
            
            HStack(
                alignment: .bottom,
                spacing: 8
            ) {
                
                TextField(
                    "Type a message...",
                    text: $messageText,
                    axis: .vertical
                )
                .font(.system(size: 9))
                .foregroundStyle(.black)
                .lineLimit(1...4)
                .padding(.horizontal, 12)
                .padding(.vertical, 9)
                .background(
                    Color(
                        red: 0.95,
                        green: 0.98,
                        blue: 0.97
                    )
                )
                .clipShape(
                    RoundedRectangle(
                        cornerRadius: 12
                    )
                )
                
                Button {
                    sendMessage()
                } label: {
                    
                    Image(
                        systemName: "arrow.up"
                    )
                    .font(
                        .system(
                            size: 10,
                            weight: .bold
                        )
                    )
                    .foregroundStyle(.white)
                    .frame(
                        width: 35,
                        height: 35
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
                .buttonStyle(.plain)
                .disabled(
                    messageText
                        .trimmingCharacters(
                            in: .whitespacesAndNewlines
                        )
                        .isEmpty
                )
                .opacity(
                    messageText
                        .trimmingCharacters(
                            in: .whitespacesAndNewlines
                        )
                        .isEmpty
                        ? 0.45
                        : 1
                )
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 9)
            .background(.white)
        }
        .navigationTitle("Chat")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    
    // MARK: - Send Message
    
    private func sendMessage() {
        
        let trimmedMessage = messageText
            .trimmingCharacters(
                in: .whitespacesAndNewlines
            )
        
        guard !trimmedMessage.isEmpty else {
            return
        }
        
        controller.sendMessage(
            text: trimmedMessage,
            requestID: request.id
        )
        
        messageText = ""
    }
}


// MARK: - Chat Bubble

struct ChatBubble: View {
    
    let message: ChatMessage
    let isCurrentUser: Bool
    
    var body: some View {
        
        HStack {
            
            if isCurrentUser {
                Spacer(minLength: 45)
            }
            
            VStack(
                alignment: isCurrentUser
                    ? .trailing
                    : .leading,
                spacing: 4
            ) {
                
                Text(message.text)
                    .font(.system(size: 9))
                    .foregroundStyle(
                        isCurrentUser
                            ? .white
                            : .black
                    )
                    .padding(.horizontal, 11)
                    .padding(.vertical, 9)
                    .background(
                        isCurrentUser
                            ? Color(
                                red: 0.00,
                                green: 0.55,
                                blue: 0.45
                            )
                            : Color.white
                    )
                    .clipShape(
                        RoundedRectangle(
                            cornerRadius: 13
                        )
                    )
                
                Text(
                    message.time
                )
                .font(.system(size: 6))
                .foregroundStyle(.gray)
            }
            
            if !isCurrentUser {
                Spacer(minLength: 45)
            }
        }
    }
}


// MARK: - Preview

#Preview {
    
    NavigationStack {
        
        ChatView(
            request: CommunityRequest(
                id: UUID(),
                title: "Help Needed",
                description: "A community member needs assistance.",
                category: .other,
                location: "Brgy. San Isidro",
                time: "9:00 AM",
                peopleNeeded: 1,
                urgency: .normal,
                requesterName: "Maria Santos",
                requesterUsername: "@maria",
                status: .inDiscussion,
                helperName: "Juan Dela Cruz"
            )
        )
        .environment(BayanihanController())
    }
}
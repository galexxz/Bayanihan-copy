import SwiftUI

struct ChatView: View {

    @Environment(BayanihanController.self) private var controller

    let request: CommunityRequest

    @State private var messageText = ""
    @State private var showAttachmentAlert = false

    private var messages: [ChatMessage] {
        controller.messages(for: request.id)
    }

    private var isRequester: Bool {
        request.requesterUsername == controller.currentUser.username
    }

    private var otherPersonName: String {

        if isRequester {
            return request.helperName ?? "Community Helper"
        }

        return request.requesterName
    }

    private var existingAgreement: HelpAgreement? {
        controller.agreement(for: request.id)
    }

    var body: some View {

        VStack(spacing: 0) {

            // MARK: - Chat Header

            HStack(spacing: 10) {

                ZStack(alignment: .bottomTrailing) {

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
                            size: 11,
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

                    Circle()
                        .fill(.green)
                        .frame(
                            width: 9,
                            height: 9
                        )
                        .overlay {
                            Circle()
                                .stroke(
                                    .white,
                                    lineWidth: 1.5
                                )
                        }
                }
                .frame(
                    width: 36,
                    height: 36
                )

                VStack(
                    alignment: .leading,
                    spacing: 2
                ) {

                    Text(otherPersonName)
                        .font(
                            .system(
                                size: 11,
                                weight: .bold
                            )
                        )
                        .foregroundStyle(.black)
                        .lineLimit(1)

                    Text(request.title)
                        .font(.system(size: 8))
                        .foregroundStyle(.gray)
                        .lineLimit(1)
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
            .padding(.horizontal, 15)
            .padding(.vertical, 12)
            .background(.white)


            // MARK: - Pinned Request Summary

            HStack(spacing: 10) {

                ZStack {

                    RoundedRectangle(
                        cornerRadius: 8
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
                    .font(.system(size: 12))
                    .foregroundStyle(
                        Color(
                            red: 0.00,
                            green: 0.55,
                            blue: 0.45
                        )
                    )
                }
                .frame(
                    width: 34,
                    height: 34
                )

                VStack(
                    alignment: .leading,
                    spacing: 2
                ) {

                    Text(request.title)
                        .font(
                            .system(
                                size: 9,
                                weight: .bold
                            )
                        )
                        .foregroundStyle(.black)
                        .lineLimit(1)

                    HStack(spacing: 4) {

                        Text(request.category.rawValue)

                        Text("·")

                        Text(request.location)
                            .lineLimit(1)
                    }
                    .font(.system(size: 7))
                    .foregroundStyle(.gray)
                }

                Spacer()

                NavigationLink {

                    RequestDetailsView(
                        request: request
                    )

                } label: {

                    Text("View")
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
            .padding(10)
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
            .padding(.horizontal, 15)
            .padding(.top, 8)


            // MARK: - Help Agreement Action

            NavigationLink {

                HelpAgreementView(
                    request: request
                )

            } label: {

                ActionButtonLabel(
                    icon: existingAgreement == nil
                        ? "checkmark.seal.fill"
                        : "doc.text.fill",
                    title: existingAgreement == nil
                        ? "Create Help Agreement"
                        : "View Agreement"
                )
            }
            .buttonStyle(.plain)
            .padding(.horizontal, 15)
            .padding(.top, 8)
            .padding(.bottom, 10)
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

                Button {
                    showAttachmentAlert = true
                } label: {

                    Image(
                        systemName: "paperclip"
                    )
                    .font(.system(size: 13))
                    .foregroundStyle(.gray)
                    .frame(
                        width: 35,
                        height: 35
                    )
                }
                .buttonStyle(.plain)

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
        .alert(
            "Attachments Unavailable",
            isPresented: $showAttachmentAlert
        ) {

            Button("OK", role: .cancel) {

            }

        } message: {

            Text(
                "Attachments are not available in this prototype."
            )
        }
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

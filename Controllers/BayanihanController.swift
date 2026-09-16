import Foundation
import SwiftUI

@MainActor
@Observable
final class BayanihanController {

    // MARK: - Session

    var isLoggedIn: Bool = false


    // MARK: - Current User

    var currentUser = BayanihanUser(
        name: "Alex Rivera",
        username: "@alexrivera",
        email: "alex@example.com",
        location: "Brgy. San Isidro",
        requestsPosted: 5,
        requestsHelped: 3,
        communityPoints: 12
    )


    // MARK: - Requests

    var requests: [CommunityRequest] = [

        CommunityRequest(
            title: "Groceries for a Senior Citizen",
            description: "Maria needs help getting groceries for her elderly mother.",
            category: .food,
            location: "Brgy. San Isidro",
            date: Date(),
            time: "9:00 AM",
            peopleNeeded: 1,
            urgency: .urgent,
            requesterName: "Maria Santos",
            requesterUsername: "@mariasantos",
            status: .open
        ),

        CommunityRequest(
            title: "Medical Supplies Needed",
            description: "A family in the community needs assistance obtaining medical supplies.",
            category: .medical,
            location: "Brgy. San Jose",
            date: Date(),
            time: "10:00 AM",
            peopleNeeded: 2,
            urgency: .urgent,
            requesterName: "Juan Dela Cruz",
            requesterUsername: "@juandelacruz",
            status: .open
        ),

        CommunityRequest(
            title: "School Supplies for Children",
            description: "Three children need school supplies before the start of classes.",
            category: .education,
            location: "Brgy. San Isidro",
            date: Date(),
            time: "2:00 PM",
            peopleNeeded: 2,
            urgency: .normal,
            requesterName: "Ana Reyes",
            requesterUsername: "@anareyes",
            status: .open
        ),

        CommunityRequest(
            title: "Community Clean-up",
            description: "Volunteers are needed for a neighborhood clean-up activity.",
            category: .volunteer,
            location: "Brgy. San Jose",
            date: Date(),
            time: "8:00 AM",
            peopleNeeded: 5,
            urgency: .normal,
            requesterName: "Barangay San Jose",
            requesterUsername: "@barangaysanjose",
            status: .open
        )
    ]


    // MARK: - Activities

    var activities: [CommunityActivity] = [

        CommunityActivity(
            id: UUID(),
            message: "Volunteered to help Maria Santos.",
            date: Date(),
            type: .volunteered
        ),

        CommunityActivity(
            id: UUID(),
            message: "Posted “School Supplies for Children.”",
            date: Date().addingTimeInterval(-3600),
            type: .posted
        ),

        CommunityActivity(
            id: UUID(),
            message: "Completed a community helping activity.",
            date: Date().addingTimeInterval(-7200),
            type: .volunteered
        ),

        CommunityActivity(
            id: UUID(),
            message: "Volunteered to help with “Groceries for a Senior Citizen.”",
            date: Date().addingTimeInterval(-5400),
            type: .volunteered,
            actorName: "Maria Santos"
        ),

        CommunityActivity(
            id: UUID(),
            message: "Posted “Medical Supplies Needed.”",
            date: Date().addingTimeInterval(-14400),
            type: .posted,
            actorName: "Juan Dela Cruz"
        ),

        CommunityActivity(
            id: UUID(),
            message: "Completed a community clean-up.",
            date: Date().addingTimeInterval(-86400),
            type: .volunteered,
            actorName: "Ana Reyes"
        )
    ]


    // MARK: - Notifications

    var notifications: [CommunityNotification] = [

        CommunityNotification(
            title: "Helper Found",
            message: "Someone offered to help with “Groceries for a Senior Citizen.”",
            icon: "hands.sparkles.fill",
            date: Date().addingTimeInterval(-1800),
            isRead: false
        ),

        CommunityNotification(
            title: "Request Posted",
            message: "Your request “School Supplies for Children” is now visible to the community.",
            icon: "megaphone.fill",
            date: Date().addingTimeInterval(-5400),
            isRead: true
        )
    ]


    // MARK: - Chat Messages

    var chatMessages: [ChatMessage] = []


    // MARK: - Help Agreements

    var helpAgreements: [HelpAgreement] = []


    // MARK: - Persistence

    // Step 3: local SwiftData-backed storage. Views never see this — the
    // Controller keeps its existing in-memory arrays/properties above as
    // the single source of truth for the UI, and mirrors changes into
    // `dataStore` so they survive relaunch.
    private let dataStore: BayanihanDataStore

    // BayanihanUser (Models/BayanihanModels.swift) has no `id` of its own,
    // so the Controller tracks the id of its persisted record here to make
    // sure profile saves update the same PersistedUser row instead of
    // inserting a new one each time.
    private var currentUserID: UUID


    // MARK: - Init

    init() {

        dataStore = Self.makeDataStore()

        if dataStore.hasSeededData() {

            // Later launch: restore everything from SwiftData instead of
            // using the demo values declared above.

            if let persistedUser = dataStore.loadUsers().first {
                currentUserID = persistedUser.id
                currentUser = BayanihanUser(persisted: persistedUser)
            } else {
                // Defensive fallback: hasSeededData() found a user record
                // but loading it back failed. Keep the in-memory demo user
                // usable and persist it under a fresh id.
                currentUserID = UUID()
                dataStore.saveUser(currentUser.toPersisted(id: currentUserID))
            }

            requests = dataStore.loadRequests().map(CommunityRequest.init(persisted:))
            activities = dataStore.loadActivities().map(CommunityActivity.init(persisted:))
            chatMessages = dataStore.loadChatMessages().map(ChatMessage.init(persisted:))
            helpAgreements = dataStore.loadHelpAgreements().map(HelpAgreement.init(persisted:))
            notifications = dataStore.loadNotifications().map(CommunityNotification.init(persisted:))

        } else {

            // First launch: the demo/seed data declared above (currentUser,
            // requests, activities, notifications) is the source of truth.
            // Save it once so future launches load from SwiftData instead
            // of reseeding.

            currentUserID = UUID()
            dataStore.saveUser(currentUser.toPersisted(id: currentUserID))

            for request in requests {
                dataStore.saveRequest(request.toPersisted())
            }

            for activity in activities {
                dataStore.saveActivity(activity.toPersisted())
            }

            for notification in notifications {
                dataStore.saveNotification(notification.toPersisted())
            }

            // chatMessages and helpAgreements start empty in the demo data,
            // so there is nothing to seed for them yet.
        }
    }


    // MARK: - DataStore Creation

    /// Builds the DataStore without ever using `try!`, a force unwrap, or
    /// `fatalError()`. Tries the normal persistent store first; if that
    /// fails, falls back to an in-memory store (BayanihanDataStore already
    /// attempts this same fallback internally, so reaching the retry loop
    /// below means even a fresh in-memory container — built from this
    /// app's own valid, hardcoded schema — failed too, which is not
    /// expected to happen in practice).
    private static func makeDataStore() -> BayanihanDataStore {

        if let store = try? BayanihanDataStore(inMemory: false) {
            return store
        }

        print("BayanihanController: Persistent DataStore unavailable — falling back to an in-memory store.")

        while true {
            if let store = try? BayanihanDataStore(inMemory: true) {
                return store
            }
        }
    }


    // MARK: - Persist Helpers

    private func persist(_ request: CommunityRequest) {
        dataStore.saveRequest(request.toPersisted())
    }

    private func persist(_ activity: CommunityActivity) {
        dataStore.saveActivity(activity.toPersisted())
    }

    private func persist(_ agreement: HelpAgreement) {
        dataStore.saveHelpAgreement(agreement.toPersisted())
    }

    private func persist(_ message: ChatMessage) {
        dataStore.saveChatMessage(message.toPersisted())
    }

    private func persistCurrentUser() {
        dataStore.saveUser(currentUser.toPersisted(id: currentUserID))
    }


    // MARK: - Add Request

    func addRequest(
        title: String,
        description: String,
        category: RequestCategory,
        location: String,
        date: Date,
        time: String,
        peopleNeeded: Int,
        urgency: RequestUrgency
    ) {

        let newRequest = CommunityRequest(
            title: title,
            description: description,
            category: category,
            location: location,
            date: date,
            time: time,
            peopleNeeded: peopleNeeded,
            urgency: urgency,
            requesterName: currentUser.name,
            requesterUsername: currentUser.username,
            status: .open
        )

        requests.insert(
            newRequest,
            at: 0
        )

        persist(newRequest)

        currentUser.requestsPosted += 1
        persistCurrentUser()

        let newActivity = CommunityActivity(
            id: UUID(),
            message: "Posted “\(newRequest.title).”",
            date: Date(),
            type: .posted
        )

        activities.insert(
            newActivity,
            at: 0
        )

        persist(newActivity)
    }


    // MARK: - Get Request

    func request(
        withID id: UUID
    ) -> CommunityRequest? {

        requests.first {
            $0.id == id
        }
    }


    // MARK: - Offer Help

    func offerHelp(
        for requestID: UUID
    ) {

        guard let index = requests.firstIndex(
            where: { $0.id == requestID }
        ) else {
            return
        }

        requests[index].status = .inDiscussion
        requests[index].helperName = currentUser.name

        persist(requests[index])

        let newActivity = CommunityActivity(
            id: UUID(),
            message: "Offered to help with “\(requests[index].title)”.",
            date: Date(),
            type: .volunteered
        )

        activities.insert(
            newActivity,
            at: 0
        )

        persist(newActivity)
    }


    // MARK: - Confirm Help

    func confirmHelp(
        for requestID: UUID
    ) {

        guard let index = requests.firstIndex(
            where: { $0.id == requestID }
        ) else {
            return
        }

        requests[index].status = .confirmed

        persist(requests[index])
    }


    // MARK: - Get Agreement

    func agreement(
        for requestID: UUID
    ) -> HelpAgreement? {

        helpAgreements.first {
            $0.requestID == requestID
        }
    }


    // MARK: - Create Agreement

    func createAgreement(
        for requestID: UUID,
        description: String,
        date: Date,
        time: String,
        location: String,
        exchangeType: ExchangeType,
        amount: Double
    ) {

        guard let request = request(withID: requestID) else {
            return
        }

        let newAgreement = HelpAgreement(
            requestID: requestID,
            requesterName: request.requesterName,
            helperName: request.helperName ?? currentUser.name,
            description: description,
            date: date,
            time: time,
            location: location,
            exchangeType: exchangeType,
            amount: amount,
            paymentStatus: exchangeType == .noPayment ? .notApplicable : .pending
        )

        helpAgreements.insert(
            newAgreement,
            at: 0
        )

        persist(newAgreement)
    }


    // MARK: - Confirm Agreement

    func confirmAgreement(
        for requestID: UUID
    ) {

        guard let index = helpAgreements.firstIndex(
            where: { $0.requestID == requestID }
        ) else {
            return
        }

        // Prototype note: a single local user stands in for both sides of
        // the conversation, so confirming finalizes the agreement for both
        // the requester and the helper at once.
        helpAgreements[index].isConfirmedByRequester = true
        helpAgreements[index].isConfirmedByHelper = true

        persist(helpAgreements[index])

        confirmHelp(for: requestID)
    }


    // MARK: - Update Payment Status

    func updatePaymentStatus(
        for requestID: UUID,
        status: PaymentStatus
    ) {

        guard let index = helpAgreements.firstIndex(
            where: { $0.requestID == requestID }
        ) else {
            return
        }

        helpAgreements[index].paymentStatus = status

        persist(helpAgreements[index])
    }


    // MARK: - Start Help

    func startHelp(
        for requestID: UUID
    ) {

        guard let index = requests.firstIndex(
            where: { $0.id == requestID }
        ) else {
            return
        }

        requests[index].status = .inProgress

        persist(requests[index])
    }


    // MARK: - Complete Help

    func completeHelp(
        for requestID: UUID
    ) {

        guard let index = requests.firstIndex(
            where: { $0.id == requestID }
        ) else {
            return
        }

        requests[index].status = .completed
        persist(requests[index])

        currentUser.requestsHelped += 1
        currentUser.communityPoints += 3
        persistCurrentUser()

        let newActivity = CommunityActivity(
            id: UUID(),
            message: "Completed “\(requests[index].title)”.",
            date: Date(),
            type: .volunteered
        )

        activities.insert(
            newActivity,
            at: 0
        )

        persist(newActivity)
    }


    // MARK: - Messages

    func messages(
        for requestID: UUID
    ) -> [ChatMessage] {

        chatMessages.filter {
            $0.requestID == requestID
        }
    }


    // MARK: - Send Message

    func sendMessage(
        text: String,
        requestID: UUID
    ) {

        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"

        let now = Date()

        let newMessage = ChatMessage(
            requestID: requestID,
            senderUsername: currentUser.username,
            text: text,
            time: formatter.string(from: now)
        )

        chatMessages.append(newMessage)

        dataStore.saveChatMessage(newMessage.toPersisted(createdAt: now))
    }


    // MARK: - Update Profile

    func updateProfile(
        name: String,
        username: String,
        email: String,
        location: String
    ) {

        currentUser.name = name
        currentUser.username = username
        currentUser.email = email
        currentUser.location = location

        persistCurrentUser()
    }


    // MARK: - Logout

    func logout() {
        // Ends the session only. Persisted profile/data intentionally stay
        // in SwiftData so they are still there the next time the user logs
        // in — only `isLoggedIn` is session state, never persisted.
        isLoggedIn = false
    }
}

import Foundation
import SwiftUI

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
            message: "You volunteered to help Maria Santos.",
            date: Date(),
            type: .volunteered
        ),
        
        CommunityActivity(
            id: UUID(),
            message: "You posted “School Supplies for Children.”",
            date: Date().addingTimeInterval(-3600),
            type: .posted
        ),
        
        CommunityActivity(
            id: UUID(),
            message: "You completed a community helping activity.",
            date: Date().addingTimeInterval(-7200),
            type: .volunteered
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

        currentUser.requestsPosted += 1
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
        
        activities.insert(
            CommunityActivity(
                id: UUID(),
                message: "You offered to help with “\(requests[index].title)”.",
                date: Date(),
                type: .volunteered
            ),
            at: 0
        )
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
        
        currentUser.requestsHelped += 1
        currentUser.communityPoints += 3
        
        activities.insert(
            CommunityActivity(
                id: UUID(),
                message: "You completed “\(requests[index].title)”.",
                date: Date(),
                type: .volunteered
            ),
            at: 0
        )
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

        let newMessage = ChatMessage(
            requestID: requestID,
            senderUsername: currentUser.username,
            text: text,
            time: formatter.string(from: Date())
        )

        chatMessages.append(newMessage)
    }


    // MARK: - Update Profile

    func updateProfile(
        name: String,
        username: String
    ) {

        currentUser.name = name
        currentUser.username = username
    }


    // MARK: - Logout

    func logout() {
        isLoggedIn = false
    }
}
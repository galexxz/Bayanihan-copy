import Foundation

// MARK: - Community Request

struct CommunityRequest: Identifiable {
    
    let id: UUID
    var title: String
    var description: String
    var category: RequestCategory
    var location: String
    var date: Date
    var time: String
    var peopleNeeded: Int
    var urgency: RequestUrgency
    
    var requesterName: String
    var requesterUsername: String
    
    var status: CommunityRequestStatus
    var helperName: String?
    
    var createdAt: Date
    
    init(
        id: UUID = UUID(),
        title: String,
        description: String,
        category: RequestCategory,
        location: String,
        date: Date = Date(),
        time: String,
        peopleNeeded: Int,
        urgency: RequestUrgency,
        requesterName: String,
        requesterUsername: String,
        status: CommunityRequestStatus = .open,
        helperName: String? = nil,
        createdAt: Date = Date()
    ) {
        self.id = id
        self.title = title
        self.description = description
        self.category = category
        self.location = location
        self.date = date
        self.time = time
        self.peopleNeeded = peopleNeeded
        self.urgency = urgency
        self.requesterName = requesterName
        self.requesterUsername = requesterUsername
        self.status = status
        self.helperName = helperName
        self.createdAt = createdAt
    }
}


// MARK: - Request Category

enum RequestCategory: String, CaseIterable, Identifiable {
    
    case food = "Food"
    case medical = "Medical"
    case education = "Education"
    case housing = "Housing"
    case donation = "Donation"
    case volunteer = "Volunteer"
    case emergency = "Emergency"
    case other = "Others"
    
    var id: String {
        rawValue
    }
    
    var icon: String {
        
        switch self {
            
        case .food:
            return "fork.knife"
            
        case .medical:
            return "cross.case.fill"
            
        case .education:
            return "book.fill"
            
        case .housing:
            return "house.fill"
            
        case .donation:
            return "gift.fill"
            
        case .volunteer:
            return "person.2.fill"
            
        case .emergency:
            return "exclamationmark.triangle.fill"
            
        case .other:
            return "square.grid.2x2.fill"
        }
    }
}


// MARK: - Request Urgency

enum RequestUrgency: String, CaseIterable, Identifiable {
    
    case normal = "Normal"
    case urgent = "Urgent"
    case emergency = "Emergency"
    
    var id: String {
        rawValue
    }
    
    var icon: String {
        
        switch self {
            
        case .normal:
            return "circle.fill"
            
        case .urgent:
            return "exclamationmark.circle.fill"
            
        case .emergency:
            return "exclamationmark.triangle.fill"
        }
    }
}


// MARK: - Community Request Status

enum CommunityRequestStatus: String, CaseIterable, Identifiable {
    
    case open = "OPEN"
    case inDiscussion = "IN DISCUSSION"
    case confirmed = "CONFIRMED"
    case inProgress = "IN PROGRESS"
    case completed = "COMPLETED"
    
    var id: String {
        rawValue
    }
    
    var icon: String {
        
        switch self {
            
        case .open:
            return "circle.fill"
            
        case .inDiscussion:
            return "message.fill"
            
        case .confirmed:
            return "handshake.fill"
            
        case .inProgress:
            return "figure.walk"
            
        case .completed:
            return "checkmark.circle.fill"
        }
    }
}


// MARK: - Help Agreement

struct HelpAgreement: Identifiable {

    let id: UUID

    var requestID: UUID
    var requesterName: String
    var helperName: String

    var description: String
    var date: Date
    var time: String
    var location: String

    var exchangeType: ExchangeType
    var amount: Double

    var paymentStatus: PaymentStatus

    var isConfirmedByRequester: Bool
    var isConfirmedByHelper: Bool

    var isConfirmed: Bool {
        isConfirmedByRequester && isConfirmedByHelper
    }

    init(
        id: UUID = UUID(),
        requestID: UUID,
        requesterName: String,
        helperName: String,
        description: String,
        date: Date,
        time: String,
        location: String,
        exchangeType: ExchangeType,
        amount: Double,
        paymentStatus: PaymentStatus = .pending,
        isConfirmedByRequester: Bool = false,
        isConfirmedByHelper: Bool = false
    ) {
        self.id = id
        self.requestID = requestID
        self.requesterName = requesterName
        self.helperName = helperName
        self.description = description
        self.date = date
        self.time = time
        self.location = location
        self.exchangeType = exchangeType
        self.amount = amount
        self.paymentStatus = paymentStatus
        self.isConfirmedByRequester = isConfirmedByRequester
        self.isConfirmedByHelper = isConfirmedByHelper
    }
}


// MARK: - Exchange Type

enum ExchangeType: String, CaseIterable, Identifiable {

    case noPayment = "No Payment"
    case cash = "Cash"
    case goods = "Goods"

    var id: String {
        rawValue
    }
}


// MARK: - Payment Status

enum PaymentStatus: String, CaseIterable, Identifiable {

    case pending = "Pending"
    case paid = "Paid"
    case notApplicable = "Not Applicable"

    var id: String {
        rawValue
    }
}


// MARK: - Activity

struct CommunityActivity: Identifiable {
    
    let id: UUID
    
    var message: String
    var date: Date
    var type: ActivityType
}


// MARK: - Activity Type

enum ActivityType: String, CaseIterable, Identifiable {
    
    case all = "All"
    case volunteered = "Volunteered"
    case posted = "Posted"
    
    var id: String {
        rawValue
    }
}


// MARK: - Current User

struct BayanihanUser {

    var name: String
    var username: String
    var email: String
    var location: String
    
    var requestsPosted: Int
    var requestsHelped: Int
    var communityPoints: Int
}


// MARK: - Chat Message

struct ChatMessage: Identifiable {

    let id: UUID

    var requestID: UUID
    var senderUsername: String
    var text: String
    var time: String

    init(
        id: UUID = UUID(),
        requestID: UUID,
        senderUsername: String,
        text: String,
        time: String
    ) {
        self.id = id
        self.requestID = requestID
        self.senderUsername = senderUsername
        self.text = text
        self.time = time
    }
}


// MARK: - Community Notification

struct CommunityNotification: Identifiable {

    let id: UUID

    var title: String
    var message: String
    var icon: String
    var date: Date
    var isRead: Bool

    init(
        id: UUID = UUID(),
        title: String,
        message: String,
        icon: String,
        date: Date = Date(),
        isRead: Bool = false
    ) {
        self.id = id
        self.title = title
        self.message = message
        self.icon = icon
        self.date = date
        self.isRead = isRead
    }
}
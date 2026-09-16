import Foundation
import SwiftData

// MARK: - Step 1: Persisted Models
//
// This file defines the SwiftData persistence layer only.
//
// The existing UI-facing structs/enums in Models/BayanihanModels.swift are
// left completely unchanged. These @Model classes are a separate, parallel
// representation used only for saving/loading data. Conversion helpers below
// translate between the two.
//
// No ModelContainer, ModelContext, or Controller wiring is introduced here.


// MARK: - RequestCategory Persistence Keys

extension RequestCategory {

    /// Stable string key used for persistence. Independent from `rawValue`
    /// (which is used for display text), so display text can change later
    /// without breaking already-stored data.
    var persistenceKey: String {

        switch self {

        case .food:
            return "food"

        case .medical:
            return "medical"

        case .education:
            return "education"

        case .housing:
            return "housing"

        case .donation:
            return "donation"

        case .volunteer:
            return "volunteer"

        case .emergency:
            return "emergency"

        case .other:
            // NOTE: RequestCategory.other has display rawValue "Others",
            // but the persistence key stays "other" and must never change.
            return "other"
        }
    }

    /// Safely reconstructs a RequestCategory from a stored persistence key.
    /// Falls back to `.other` for any unknown/future value instead of
    /// crashing.
    init(persistenceKey: String) {

        switch persistenceKey {

        case "food":
            self = .food

        case "medical":
            self = .medical

        case "education":
            self = .education

        case "housing":
            self = .housing

        case "donation":
            self = .donation

        case "volunteer":
            self = .volunteer

        case "emergency":
            self = .emergency

        default:
            self = .other
        }
    }
}


// MARK: - RequestUrgency Persistence Keys

extension RequestUrgency {

    var persistenceKey: String {

        switch self {

        case .normal:
            return "normal"

        case .urgent:
            return "urgent"

        case .emergency:
            return "emergency"
        }
    }

    init(persistenceKey: String) {

        switch persistenceKey {

        case "urgent":
            self = .urgent

        case "emergency":
            self = .emergency

        default:
            self = .normal
        }
    }
}


// MARK: - CommunityRequestStatus Persistence Keys

extension CommunityRequestStatus {

    var persistenceKey: String {

        switch self {

        case .open:
            return "open"

        case .inDiscussion:
            return "inDiscussion"

        case .confirmed:
            return "confirmed"

        case .inProgress:
            return "inProgress"

        case .completed:
            return "completed"
        }
    }

    init(persistenceKey: String) {

        switch persistenceKey {

        case "inDiscussion":
            self = .inDiscussion

        case "confirmed":
            self = .confirmed

        case "inProgress":
            self = .inProgress

        case "completed":
            self = .completed

        default:
            self = .open
        }
    }
}


// MARK: - ExchangeType Persistence Keys

extension ExchangeType {

    var persistenceKey: String {

        switch self {

        case .noPayment:
            return "noPayment"

        case .cash:
            return "cash"

        case .goods:
            return "goods"
        }
    }

    init(persistenceKey: String) {

        switch persistenceKey {

        case "cash":
            self = .cash

        case "goods":
            self = .goods

        default:
            self = .noPayment
        }
    }
}


// MARK: - PaymentStatus Persistence Keys

extension PaymentStatus {

    var persistenceKey: String {

        switch self {

        case .pending:
            return "pending"

        case .paid:
            return "paid"

        case .notApplicable:
            return "notApplicable"
        }
    }

    init(persistenceKey: String) {

        switch persistenceKey {

        case "paid":
            self = .paid

        case "notApplicable":
            self = .notApplicable

        default:
            self = .pending
        }
    }
}


// MARK: - ActivityType Persistence Keys

extension ActivityType {

    var persistenceKey: String {

        switch self {

        case .all:
            return "all"

        case .volunteered:
            return "volunteered"

        case .posted:
            return "posted"
        }
    }

    init(persistenceKey: String) {

        switch persistenceKey {

        case "all":
            self = .all

        case "volunteered":
            self = .volunteered

        default:
            self = .posted
        }
    }
}


// MARK: - Persisted User

@Model
final class PersistedUser {

    @Attribute(.unique) var id: UUID

    var name: String
    var username: String
    var email: String
    var location: String

    var requestsPosted: Int
    var requestsHelped: Int
    var communityPoints: Int

    init(
        id: UUID = UUID(),
        name: String,
        username: String,
        email: String,
        location: String,
        requestsPosted: Int,
        requestsHelped: Int,
        communityPoints: Int
    ) {
        self.id = id
        self.name = name
        self.username = username
        self.email = email
        self.location = location
        self.requestsPosted = requestsPosted
        self.requestsHelped = requestsHelped
        self.communityPoints = communityPoints
    }
}


// MARK: - Persisted Request

@Model
final class PersistedRequest {

    @Attribute(.unique) var id: UUID

    var title: String
    var requestDescription: String
    var categoryKey: String
    var location: String
    var date: Date
    var time: String
    var peopleNeeded: Int
    var urgencyKey: String

    var requesterName: String
    var requesterUsername: String

    var statusKey: String
    var helperName: String?

    var createdAt: Date

    init(
        id: UUID = UUID(),
        title: String,
        requestDescription: String,
        categoryKey: String,
        location: String,
        date: Date,
        time: String,
        peopleNeeded: Int,
        urgencyKey: String,
        requesterName: String,
        requesterUsername: String,
        statusKey: String,
        helperName: String? = nil,
        createdAt: Date
    ) {
        self.id = id
        self.title = title
        self.requestDescription = requestDescription
        self.categoryKey = categoryKey
        self.location = location
        self.date = date
        self.time = time
        self.peopleNeeded = peopleNeeded
        self.urgencyKey = urgencyKey
        self.requesterName = requesterName
        self.requesterUsername = requesterUsername
        self.statusKey = statusKey
        self.helperName = helperName
        self.createdAt = createdAt
    }
}


// MARK: - Persisted Activity

@Model
final class PersistedActivity {

    @Attribute(.unique) var id: UUID

    var message: String
    var date: Date
    var typeKey: String
    var actorName: String

    init(
        id: UUID = UUID(),
        message: String,
        date: Date,
        typeKey: String,
        actorName: String
    ) {
        self.id = id
        self.message = message
        self.date = date
        self.typeKey = typeKey
        self.actorName = actorName
    }
}


// MARK: - Persisted Chat Message

@Model
final class PersistedChatMessage {

    @Attribute(.unique) var id: UUID

    var requestID: UUID
    var senderUsername: String
    var text: String

    /// Existing display-formatted string (e.g. "9:00 AM"), preserved exactly
    /// as produced by ChatMessage so the View can remain unchanged.
    var time: String

    /// Persistence-only value used to reliably reorder messages after
    /// loading from SwiftData. `ChatMessage` itself is not modified to add
    /// this property.
    var createdAt: Date

    init(
        id: UUID = UUID(),
        requestID: UUID,
        senderUsername: String,
        text: String,
        time: String,
        createdAt: Date = Date()
    ) {
        self.id = id
        self.requestID = requestID
        self.senderUsername = senderUsername
        self.text = text
        self.time = time
        self.createdAt = createdAt
    }
}


// MARK: - Persisted Help Agreement

@Model
final class PersistedHelpAgreement {

    @Attribute(.unique) var id: UUID

    var requestID: UUID
    var requesterName: String
    var helperName: String

    var agreementDescription: String
    var date: Date
    var time: String
    var location: String

    var exchangeTypeKey: String
    var amount: Double

    var paymentStatusKey: String

    var isConfirmedByRequester: Bool
    var isConfirmedByHelper: Bool

    // NOTE: `isConfirmed` on HelpAgreement is a computed property
    // (isConfirmedByRequester && isConfirmedByHelper) and is intentionally
    // not persisted.

    init(
        id: UUID = UUID(),
        requestID: UUID,
        requesterName: String,
        helperName: String,
        agreementDescription: String,
        date: Date,
        time: String,
        location: String,
        exchangeTypeKey: String,
        amount: Double,
        paymentStatusKey: String,
        isConfirmedByRequester: Bool,
        isConfirmedByHelper: Bool
    ) {
        self.id = id
        self.requestID = requestID
        self.requesterName = requesterName
        self.helperName = helperName
        self.agreementDescription = agreementDescription
        self.date = date
        self.time = time
        self.location = location
        self.exchangeTypeKey = exchangeTypeKey
        self.amount = amount
        self.paymentStatusKey = paymentStatusKey
        self.isConfirmedByRequester = isConfirmedByRequester
        self.isConfirmedByHelper = isConfirmedByHelper
    }
}


// MARK: - Persisted Notification

@Model
final class PersistedNotification {

    @Attribute(.unique) var id: UUID

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
        date: Date,
        isRead: Bool
    ) {
        self.id = id
        self.title = title
        self.message = message
        self.icon = icon
        self.date = date
        self.isRead = isRead
    }
}


// MARK: - Conversion: CommunityRequest <-> PersistedRequest

extension CommunityRequest {

    /// Builds a PersistedRequest snapshot, preserving the id exactly.
    func toPersisted() -> PersistedRequest {

        PersistedRequest(
            id: id,
            title: title,
            requestDescription: description,
            categoryKey: category.persistenceKey,
            location: location,
            date: date,
            time: time,
            peopleNeeded: peopleNeeded,
            urgencyKey: urgency.persistenceKey,
            requesterName: requesterName,
            requesterUsername: requesterUsername,
            statusKey: status.persistenceKey,
            helperName: helperName,
            createdAt: createdAt
        )
    }

    init(persisted: PersistedRequest) {

        self.init(
            id: persisted.id,
            title: persisted.title,
            description: persisted.requestDescription,
            category: RequestCategory(persistenceKey: persisted.categoryKey),
            location: persisted.location,
            date: persisted.date,
            time: persisted.time,
            peopleNeeded: persisted.peopleNeeded,
            urgency: RequestUrgency(persistenceKey: persisted.urgencyKey),
            requesterName: persisted.requesterName,
            requesterUsername: persisted.requesterUsername,
            status: CommunityRequestStatus(persistenceKey: persisted.statusKey),
            helperName: persisted.helperName,
            createdAt: persisted.createdAt
        )
    }
}


// MARK: - Conversion: BayanihanUser <-> PersistedUser

extension BayanihanUser {

    /// Builds a PersistedUser snapshot.
    ///
    /// NOTE: BayanihanUser has no `id` property of its own (there is a
    /// single local current user in the prototype), so there is no existing
    /// identifier to preserve here. Pass an existing `id` explicitly (e.g.
    /// the id of a previously persisted record) to update in place; when
    /// omitted a new identifier is generated.
    func toPersisted(id: UUID = UUID()) -> PersistedUser {

        PersistedUser(
            id: id,
            name: name,
            username: username,
            email: email,
            location: location,
            requestsPosted: requestsPosted,
            requestsHelped: requestsHelped,
            communityPoints: communityPoints
        )
    }

    init(persisted: PersistedUser) {

        self.init(
            name: persisted.name,
            username: persisted.username,
            email: persisted.email,
            location: persisted.location,
            requestsPosted: persisted.requestsPosted,
            requestsHelped: persisted.requestsHelped,
            communityPoints: persisted.communityPoints
        )
    }
}


// MARK: - Conversion: CommunityActivity <-> PersistedActivity

extension CommunityActivity {

    func toPersisted() -> PersistedActivity {

        PersistedActivity(
            id: id,
            message: message,
            date: date,
            typeKey: type.persistenceKey,
            actorName: actorName
        )
    }

    init(persisted: PersistedActivity) {

        self.init(
            id: persisted.id,
            message: persisted.message,
            date: persisted.date,
            type: ActivityType(persistenceKey: persisted.typeKey),
            actorName: persisted.actorName
        )
    }
}


// MARK: - Conversion: ChatMessage <-> PersistedChatMessage

extension ChatMessage {

    /// Builds a PersistedChatMessage snapshot. `time` (the existing
    /// display-formatted string) is carried over unchanged; `createdAt` is
    /// a persistence-only ordering value, defaulting to now for messages
    /// that predate persistence.
    func toPersisted(createdAt: Date = Date()) -> PersistedChatMessage {

        PersistedChatMessage(
            id: id,
            requestID: requestID,
            senderUsername: senderUsername,
            text: text,
            time: time,
            createdAt: createdAt
        )
    }

    init(persisted: PersistedChatMessage) {

        self.init(
            id: persisted.id,
            requestID: persisted.requestID,
            senderUsername: persisted.senderUsername,
            text: persisted.text,
            time: persisted.time
        )
    }
}


// MARK: - Conversion: HelpAgreement <-> PersistedHelpAgreement

extension HelpAgreement {

    func toPersisted() -> PersistedHelpAgreement {

        PersistedHelpAgreement(
            id: id,
            requestID: requestID,
            requesterName: requesterName,
            helperName: helperName,
            agreementDescription: description,
            date: date,
            time: time,
            location: location,
            exchangeTypeKey: exchangeType.persistenceKey,
            amount: amount,
            paymentStatusKey: paymentStatus.persistenceKey,
            isConfirmedByRequester: isConfirmedByRequester,
            isConfirmedByHelper: isConfirmedByHelper
        )
    }

    init(persisted: PersistedHelpAgreement) {

        self.init(
            id: persisted.id,
            requestID: persisted.requestID,
            requesterName: persisted.requesterName,
            helperName: persisted.helperName,
            description: persisted.agreementDescription,
            date: persisted.date,
            time: persisted.time,
            location: persisted.location,
            exchangeType: ExchangeType(persistenceKey: persisted.exchangeTypeKey),
            amount: persisted.amount,
            paymentStatus: PaymentStatus(persistenceKey: persisted.paymentStatusKey),
            isConfirmedByRequester: persisted.isConfirmedByRequester,
            isConfirmedByHelper: persisted.isConfirmedByHelper
        )
    }
}


// MARK: - Conversion: CommunityNotification <-> PersistedNotification

extension CommunityNotification {

    func toPersisted() -> PersistedNotification {

        PersistedNotification(
            id: id,
            title: title,
            message: message,
            icon: icon,
            date: date,
            isRead: isRead
        )
    }

    init(persisted: PersistedNotification) {

        self.init(
            id: persisted.id,
            title: persisted.title,
            message: persisted.message,
            icon: persisted.icon,
            date: persisted.date,
            isRead: persisted.isRead
        )
    }
}

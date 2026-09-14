import SwiftUI

struct HelpAgreementView: View {

    @Environment(BayanihanController.self) private var controller
    @Environment(\.dismiss) private var dismiss

    let request: CommunityRequest

    @State private var description = ""
    @State private var date = Date()
    @State private var time = ""
    @State private var location = ""
    @State private var exchangeType: ExchangeType = .noPayment
    @State private var amountText = ""

    @State private var showValidationAlert = false
    @State private var validationMessage = ""
    @State private var showConfirmedScreen = false

    private var isRequester: Bool {
        request.requesterUsername == controller.currentUser.username
    }

    private var existingAgreement: HelpAgreement? {
        controller.agreement(for: request.id)
    }

    private var helperDisplayName: String {
        request.helperName ?? controller.currentUser.name
    }

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

                    // MARK: - Header

                    Text("Help Agreement")
                        .font(
                            .system(
                                size: 22,
                                weight: .bold
                            )
                        )
                        .foregroundStyle(.black)
                        .padding(.top, 15)

                    HStack(spacing: 4) {

                        Text("Agreement between")
                            .foregroundStyle(.gray)

                        Text(request.requesterName)
                            .fontWeight(.bold)
                            .foregroundStyle(.black)

                        Text("and")
                            .foregroundStyle(.gray)

                        Text(helperDisplayName)
                            .fontWeight(.bold)
                            .foregroundStyle(.black)
                    }
                    .font(.system(size: 9))
                    .padding(.top, 4)


                    // MARK: - Request Info Box

                    VStack(
                        alignment: .leading,
                        spacing: 10
                    ) {

                        HStack(spacing: 8) {

                            Image(
                                systemName: request.category.icon
                            )
                            .font(.system(size: 11))
                            .foregroundStyle(
                                Color(
                                    red: 0.00,
                                    green: 0.55,
                                    blue: 0.45
                                )
                            )

                            Text(request.title)
                                .font(
                                    .system(
                                        size: 11,
                                        weight: .bold
                                    )
                                )
                                .foregroundStyle(.black)
                                .lineLimit(2)

                            Spacer()

                            Text(
                                request.status.rawValue.uppercased()
                            )
                            .font(
                                .system(
                                    size: 6,
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
                            .padding(.horizontal, 7)
                            .padding(.vertical, 5)
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

                        HStack(spacing: 12) {

                            Label(
                                request.category.rawValue,
                                systemImage: "tag.fill"
                            )

                            Label(
                                request.location,
                                systemImage: "mappin.and.ellipse"
                            )
                        }
                        .font(.system(size: 7))
                        .foregroundStyle(.gray)
                    }
                    .padding(14)
                    .background(.white)
                    .clipShape(
                        RoundedRectangle(
                            cornerRadius: 14
                        )
                    )
                    .padding(.top, 14)


                    if let agreement = existingAgreement {

                        agreementSummary(agreement)

                    } else {

                        agreementForm
                    }

                    Spacer(minLength: 30)
                }
                .padding(.horizontal, 20)
            }
        }
        .navigationTitle("Help Agreement")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            loadDefaults()
        }
        .navigationDestination(
            isPresented: $showConfirmedScreen
        ) {
            HelpConfirmedView(
                request: request
            )
        }
        .alert(
            "Unable to Save Agreement",
            isPresented: $showValidationAlert
        ) {

            Button("OK", role: .cancel) {

            }

        } message: {

            Text(validationMessage)
        }
    }


    // MARK: - Load Defaults

    private func loadDefaults() {

        description = request.description
        time = request.time
        location = request.location
    }


    // MARK: - Agreement Form

    private var agreementForm: some View {

        VStack(
            alignment: .leading,
            spacing: 0
        ) {

            // MARK: - Section Title

            Text("Agreement Details")
                .font(
                    .system(
                        size: 13,
                        weight: .bold
                    )
                )
                .foregroundStyle(.black)
                .padding(.top, 22)


            // MARK: - Description

            FormFieldTitle(
                title: "Help Description"
            )
            .padding(.top, 12)

            TextField(
                "Describe what the helper will do...",
                text: $description,
                axis: .vertical
            )
            .font(.system(size: 9))
            .foregroundStyle(.black)
            .lineLimit(3...6)
            .padding(12)
            .frame(
                minHeight: 80,
                alignment: .topLeading
            )
            .background(.white)
            .clipShape(
                RoundedRectangle(
                    cornerRadius: 11
                )
            )
            .padding(.top, 8)


            // MARK: - Date

            FormFieldTitle(
                title: "Date"
            )
            .padding(.top, 17)

            DatePicker(
                "",
                selection: $date,
                displayedComponents: .date
            )
            .labelsHidden()
            .datePickerStyle(.compact)
            .padding(.horizontal, 12)
            .frame(height: 45)
            .frame(
                maxWidth: .infinity,
                alignment: .leading
            )
            .background(.white)
            .clipShape(
                RoundedRectangle(
                    cornerRadius: 11
                )
            )
            .padding(.top, 8)


            // MARK: - Time

            FormFieldTitle(
                title: "Time"
            )
            .padding(.top, 17)

            TextField(
                "Example: Tomorrow, 9:00 AM",
                text: $time
            )
            .font(.system(size: 9))
            .foregroundStyle(.black)
            .padding(.horizontal, 12)
            .frame(height: 45)
            .background(.white)
            .clipShape(
                RoundedRectangle(
                    cornerRadius: 11
                )
            )
            .padding(.top, 8)


            // MARK: - Location

            FormFieldTitle(
                title: "Location"
            )
            .padding(.top, 17)

            TextField(
                "Where will the help take place?",
                text: $location
            )
            .font(.system(size: 9))
            .foregroundStyle(.black)
            .padding(.horizontal, 12)
            .frame(height: 45)
            .background(.white)
            .clipShape(
                RoundedRectangle(
                    cornerRadius: 11
                )
            )
            .padding(.top, 8)


            // MARK: - Exchange Type

            FormFieldTitle(
                title: "Exchange / Reimbursement"
            )
            .padding(.top, 17)

            HStack(spacing: 7) {

                ForEach(
                    ExchangeType.allCases
                ) { type in

                    Button {
                        exchangeType = type
                    } label: {

                        Text(type.rawValue)
                            .font(
                                .system(
                                    size: 8,
                                    weight: .semibold
                                )
                            )
                            .foregroundStyle(
                                exchangeType == type
                                    ? .white
                                    : .black
                            )
                            .padding(.horizontal, 10)
                            .frame(height: 32)
                            .background(
                                exchangeType == type
                                    ? Color(
                                        red: 0.00,
                                        green: 0.55,
                                        blue: 0.45
                                    )
                                    : Color.white
                            )
                            .clipShape(
                                RoundedRectangle(
                                    cornerRadius: 9
                                )
                            )
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.top, 8)


            // MARK: - Amount

            if exchangeType != .noPayment {

                FormFieldTitle(
                    title: "Amount (₱)"
                )
                .padding(.top, 17)

                TextField(
                    "0",
                    text: $amountText
                )
                .keyboardType(.decimalPad)
                .font(.system(size: 9))
                .foregroundStyle(.black)
                .padding(.horizontal, 12)
                .frame(height: 45)
                .background(.white)
                .clipShape(
                    RoundedRectangle(
                        cornerRadius: 11
                    )
                )
                .padding(.top, 8)
            }


            // MARK: - Warning Note

            warningNote
                .padding(.top, 20)


            // MARK: - Save

            Button {
                saveAgreement()
            } label: {

                HStack(spacing: 8) {

                    Image(
                        systemName: "doc.badge.plus"
                    )

                    Text("Save Agreement")
                        .font(
                            .system(
                                size: 11,
                                weight: .bold
                            )
                        )
                }
                .foregroundStyle(.white)
                .frame(
                    maxWidth: .infinity
                )
                .frame(height: 50)
                .background(
                    Color(
                        red: 0.00,
                        green: 0.55,
                        blue: 0.45
                    )
                )
                .clipShape(
                    RoundedRectangle(
                        cornerRadius: 14
                    )
                )
            }
            .buttonStyle(.plain)
            .padding(.top, 20)

            cancelLink
                .padding(.top, 12)
        }
    }


    // MARK: - Save Agreement

    private func saveAgreement() {

        let cleanDescription = description
            .trimmingCharacters(
                in: .whitespacesAndNewlines
            )

        let cleanTime = time
            .trimmingCharacters(
                in: .whitespacesAndNewlines
            )

        let cleanLocation = location
            .trimmingCharacters(
                in: .whitespacesAndNewlines
            )

        guard !cleanDescription.isEmpty else {
            showValidation(
                "Please describe the help being agreed to."
            )
            return
        }

        guard !cleanTime.isEmpty else {
            showValidation(
                "Please enter a time for the agreement."
            )
            return
        }

        guard !cleanLocation.isEmpty else {
            showValidation(
                "Please enter a location for the agreement."
            )
            return
        }

        var amount: Double = 0

        if exchangeType != .noPayment {

            guard
                let parsedAmount = Double(amountText),
                parsedAmount > 0
            else {
                showValidation(
                    "Please enter a valid amount."
                )
                return
            }

            amount = parsedAmount
        }

        controller.createAgreement(
            for: request.id,
            description: cleanDescription,
            date: date,
            time: cleanTime,
            location: cleanLocation,
            exchangeType: exchangeType,
            amount: amount
        )
    }


    // MARK: - Validation

    private func showValidation(
        _ message: String
    ) {
        validationMessage = message
        showValidationAlert = true
    }


    // MARK: - Agreement Summary

    private func agreementSummary(
        _ agreement: HelpAgreement
    ) -> some View {

        VStack(
            alignment: .leading,
            spacing: 0
        ) {

            // MARK: - Summary Card

            VStack(
                alignment: .leading,
                spacing: 12
            ) {

                DetailInfoRow(
                    icon: "person.fill",
                    title: "Person Needing Help",
                    value: agreement.requesterName
                )

                DetailInfoRow(
                    icon: "hands.sparkles.fill",
                    title: "Helper",
                    value: agreement.helperName
                )

                DetailInfoRow(
                    icon: "text.alignleft",
                    title: "Help Description",
                    value: agreement.description
                )

                DetailInfoRow(
                    icon: "calendar",
                    title: "Date",
                    value: formattedDate(agreement.date)
                )

                DetailInfoRow(
                    icon: "clock",
                    title: "Time",
                    value: agreement.time
                )

                DetailInfoRow(
                    icon: "mappin.and.ellipse",
                    title: "Location",
                    value: agreement.location
                )
            }
            .padding(14)
            .background(.white)
            .clipShape(
                RoundedRectangle(
                    cornerRadius: 14
                )
            )
            .padding(.top, 20)


            // MARK: - Reimbursement

            Text("Reimbursement")
                .font(
                    .system(
                        size: 13,
                        weight: .bold
                    )
                )
                .foregroundStyle(.black)
                .padding(.top, 23)

            reimbursementCard(agreement)
                .padding(.top, 10)


            // MARK: - Confirmation Status

            Text("Agreement Confirmation")
                .font(
                    .system(
                        size: 13,
                        weight: .bold
                    )
                )
                .foregroundStyle(.black)
                .padding(.top, 23)

            VStack(spacing: 9) {

                ConfirmationRow(
                    name: agreement.requesterName,
                    role: "Person Needing Help",
                    isConfirmed: agreement.isConfirmedByRequester
                )

                ConfirmationRow(
                    name: agreement.helperName,
                    role: "Helper",
                    isConfirmed: agreement.isConfirmedByHelper
                )
            }
            .padding(.top, 10)


            // MARK: - Confirm Button

            if isRequester && !agreement.isConfirmed {

                warningNote
                    .padding(.top, 20)

                Button {
                    controller.confirmAgreement(
                        for: request.id
                    )

                    showConfirmedScreen = true

                } label: {

                    HStack(spacing: 8) {

                        Image(
                            systemName: "checkmark.seal.fill"
                        )

                        Text("Confirm Agreement")
                            .font(
                                .system(
                                    size: 11,
                                    weight: .bold
                                )
                            )
                    }
                    .foregroundStyle(.white)
                    .frame(
                        maxWidth: .infinity
                    )
                    .frame(height: 50)
                    .background(
                        Color(
                            red: 0.00,
                            green: 0.55,
                            blue: 0.45
                        )
                    )
                    .clipShape(
                        RoundedRectangle(
                            cornerRadius: 14
                        )
                    )
                }
                .buttonStyle(.plain)
                .padding(.top, 14)

                cancelLink
                    .padding(.top, 12)
            }


            // MARK: - Mark as Paid

            if isRequester &&
                agreement.isConfirmed &&
                agreement.exchangeType != .noPayment &&
                agreement.paymentStatus == .pending {

                Button {
                    controller.updatePaymentStatus(
                        for: request.id,
                        status: .paid
                    )
                } label: {

                    HStack(spacing: 8) {

                        Image(
                            systemName: "checkmark.circle.fill"
                        )

                        Text("Mark as Paid")
                            .font(
                                .system(
                                    size: 11,
                                    weight: .bold
                                )
                            )
                    }
                    .foregroundStyle(.white)
                    .frame(
                        maxWidth: .infinity
                    )
                    .frame(height: 50)
                    .background(
                        Color(
                            red: 0.00,
                            green: 0.55,
                            blue: 0.45
                        )
                    )
                    .clipShape(
                        RoundedRectangle(
                            cornerRadius: 14
                        )
                    )
                }
                .buttonStyle(.plain)
                .padding(.top, 12)
            }
        }
    }


    // MARK: - Reimbursement Card

    private func reimbursementCard(
        _ agreement: HelpAgreement
    ) -> some View {

        HStack {

            if agreement.exchangeType == .noPayment {

                HStack(spacing: 8) {

                    Image(
                        systemName: "heart.fill"
                    )
                    .foregroundStyle(
                        Color(
                            red: 0.00,
                            green: 0.55,
                            blue: 0.45
                        )
                    )

                    Text("No reimbursement")
                        .font(
                            .system(
                                size: 10,
                                weight: .semibold
                            )
                        )
                        .foregroundStyle(.black)
                }

                Spacer()

            } else {

                VStack(
                    alignment: .leading,
                    spacing: 3
                ) {

                    Text(
                        formattedAmount(agreement.amount)
                    )
                    .font(
                        .system(
                            size: 17,
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

                    Text(agreement.exchangeType.rawValue)
                        .font(.system(size: 8))
                        .foregroundStyle(.gray)
                }

                Spacer()

                Text(
                    agreement.paymentStatus.rawValue.uppercased()
                )
                .font(
                    .system(
                        size: 7,
                        weight: .bold
                    )
                )
                .foregroundStyle(
                    paymentStatusColor(agreement.paymentStatus)
                )
                .padding(.horizontal, 9)
                .padding(.vertical, 6)
                .background(
                    paymentStatusColor(agreement.paymentStatus)
                        .opacity(0.10)
                )
                .clipShape(Capsule())
            }
        }
        .padding(14)
        .background(.white)
        .clipShape(
            RoundedRectangle(
                cornerRadius: 14
            )
        )
    }


    // MARK: - Payment Status Color

    private func paymentStatusColor(
        _ status: PaymentStatus
    ) -> Color {

        switch status {
        case .pending:
            return .orange

        case .paid:
            return Color(
                red: 0.00,
                green: 0.55,
                blue: 0.45
            )

        case .notApplicable:
            return .gray
        }
    }


    // MARK: - Warning Note

    private var warningNote: some View {

        HStack(
            alignment: .top,
            spacing: 8
        ) {

            Image(
                systemName: "exclamationmark.triangle.fill"
            )
            .font(.system(size: 11))
            .foregroundStyle(
                Color(
                    red: 0.80,
                    green: 0.60,
                    blue: 0.10
                )
            )

            Text(
                "Before confirming, make sure you both agree on the details above."
            )
            .font(.system(size: 8))
            .foregroundStyle(
                Color(
                    red: 0.55,
                    green: 0.42,
                    blue: 0.05
                )
            )
        }
        .padding(12)
        .background(
            Color(
                red: 1.0,
                green: 0.95,
                blue: 0.80
            )
        )
        .clipShape(
            RoundedRectangle(
                cornerRadius: 11
            )
        )
    }


    // MARK: - Cancel Link

    private var cancelLink: some View {

        Button {
            dismiss()
        } label: {

            Text("Cancel")
                .font(
                    .system(
                        size: 10,
                        weight: .semibold
                    )
                )
                .foregroundStyle(.gray)
                .frame(maxWidth: .infinity)
        }
        .buttonStyle(.plain)
    }


    // MARK: - Formatted Amount

    private func formattedAmount(
        _ amount: Double
    ) -> String {

        if amount == amount.rounded() {
            return "₱\(Int(amount))"
        }

        return String(format: "₱%.2f", amount)
    }


    // MARK: - Formatted Date

    private func formattedDate(
        _ date: Date
    ) -> String {

        let formatter = DateFormatter()
        formatter.dateStyle = .medium

        return formatter.string(from: date)
    }
}


// MARK: - Confirmation Row

struct ConfirmationRow: View {

    let name: String
    let role: String
    let isConfirmed: Bool

    var body: some View {

        HStack(spacing: 11) {

            Image(
                systemName: isConfirmed
                    ? "checkmark.circle.fill"
                    : "clock.fill"
            )
            .font(.system(size: 14))
            .foregroundStyle(
                isConfirmed
                    ? Color(
                        red: 0.00,
                        green: 0.55,
                        blue: 0.45
                    )
                    : .gray
            )

            VStack(
                alignment: .leading,
                spacing: 2
            ) {

                Text(name)
                    .font(
                        .system(
                            size: 9,
                            weight: .semibold
                        )
                    )
                    .foregroundStyle(.black)

                Text(role)
                    .font(.system(size: 7))
                    .foregroundStyle(.gray)
            }

            Spacer()

            Text(
                isConfirmed
                    ? "Confirmed"
                    : "Pending"
            )
            .font(
                .system(
                    size: 7,
                    weight: .bold
                )
            )
            .foregroundStyle(
                isConfirmed
                    ? Color(
                        red: 0.00,
                        green: 0.55,
                        blue: 0.45
                    )
                    : .gray
            )
            .padding(.horizontal, 8)
            .padding(.vertical, 5)
            .background(
                (
                    isConfirmed
                        ? Color(
                            red: 0.00,
                            green: 0.55,
                            blue: 0.45
                        )
                        : Color.gray
                )
                .opacity(0.10)
            )
            .clipShape(Capsule())
        }
        .padding(13)
        .background(.white)
        .clipShape(
            RoundedRectangle(
                cornerRadius: 14
            )
        )
    }
}


// MARK: - Preview

#Preview {

    NavigationStack {

        HelpAgreementView(
            request: CommunityRequest(
                id: UUID(),
                title: "Groceries for a Senior Citizen",
                description: "Maria needs help getting groceries for her elderly mother.",
                category: .food,
                location: "Brgy. San Isidro",
                time: "9:00 AM",
                peopleNeeded: 1,
                urgency: .urgent,
                requesterName: "Maria Santos",
                requesterUsername: "@maria",
                status: .inDiscussion,
                helperName: "Alex Rivera"
            )
        )
        .environment(BayanihanController())
    }
}

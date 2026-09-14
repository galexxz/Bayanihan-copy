import SwiftUI

struct PostRequestView: View {
    
    @Environment(BayanihanController.self) private var controller
    @Environment(\.dismiss) private var dismiss
    
    @State private var title = ""
    @State private var description = ""
    @State private var selectedCategory: RequestCategory = .other
    @State private var selectedUrgency: RequestUrgency = .normal
    @State private var location = ""
    @State private var requestDate = Date()
    @State private var time = ""
    @State private var peopleNeeded = ""
    
    @State private var showValidationAlert = false
    @State private var validationMessage = ""
    
    var body: some View {

        NavigationStack {

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

                        Text("Post a Request")
                            .font(
                                .system(
                                    size: 22,
                                    weight: .bold
                                )
                            )
                            .foregroundStyle(.black)
                            .padding(.top, 15)

                        Text(
                            "Tell your community what you need."
                        )
                        .font(.system(size: 9))
                        .foregroundStyle(.gray)
                        .padding(.top, 4)


                        // MARK: - Request Title

                        FormFieldTitle(
                            title: "Request Title *"
                        )
                        .padding(.top, 20)

                        TextField(
                            "What do you need help with?",
                            text: $title
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
                        
                        
                        // MARK: - Description
                        
                        FormFieldTitle(
                            title: "Description *"
                        )
                        .padding(.top, 17)
                        
                        TextField(
                            "Explain what kind of help you need...",
                            text: $description,
                            axis: .vertical
                        )
                        .font(.system(size: 9))
                        .foregroundStyle(.black)
                        .lineLimit(3...6)
                        .padding(12)
                        .frame(
                            minHeight: 95,
                            alignment: .topLeading
                        )
                        .background(.white)
                        .clipShape(
                            RoundedRectangle(
                                cornerRadius: 11
                            )
                        )
                        .padding(.top, 8)
                        
                        
                        // MARK: - Category
                        
                        FormFieldTitle(
                            title: "Category"
                        )
                        .padding(.top, 17)
                        
                        ScrollView(
                            .horizontal,
                            showsIndicators: false
                        ) {
                            
                            HStack(spacing: 7) {
                                
                                ForEach(
                                    RequestCategory.allCases
                                ) { category in
                                    
                                    Button {
                                        selectedCategory = category
                                    } label: {
                                        
                                        HStack(spacing: 5) {
                                            
                                            Image(
                                                systemName: category.icon
                                            )
                                            .font(.system(size: 8))
                                            
                                            Text(
                                                category.rawValue
                                            )
                                            .font(
                                                .system(
                                                    size: 8,
                                                    weight: .semibold
                                                )
                                            )
                                        }
                                        .foregroundStyle(
                                            selectedCategory == category
                                                ? .white
                                                : .black
                                        )
                                        .padding(.horizontal, 10)
                                        .frame(height: 32)
                                        .background(
                                            selectedCategory == category
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
                        }
                        .padding(.top, 8)
                        
                        
                        // MARK: - Urgency
                        
                        FormFieldTitle(
                            title: "Urgency"
                        )
                        .padding(.top, 17)
                        
                        HStack(spacing: 7) {
                            
                            ForEach(
                                RequestUrgency.allCases
                            ) { urgency in
                                
                                Button {
                                    selectedUrgency = urgency
                                } label: {
                                    
                                    Text(
                                        urgency.rawValue
                                    )
                                    .font(
                                        .system(
                                            size: 8,
                                            weight: .semibold
                                        )
                                    )
                                    .foregroundStyle(
                                        selectedUrgency == urgency
                                            ? .white
                                            : .black
                                    )
                                    .padding(.horizontal, 12)
                                    .frame(height: 32)
                                    .background(
                                        selectedUrgency == urgency
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
                        
                        
                        // MARK: - Location
                        
                        FormFieldTitle(
                            title: "Location *"
                        )
                        .padding(.top, 17)
                        
                        HStack(spacing: 8) {
                            
                            Image(
                                systemName: "mappin.and.ellipse"
                            )
                            .font(.system(size: 10))
                            .foregroundStyle(
                                Color(
                                    red: 0.00,
                                    green: 0.55,
                                    blue: 0.45
                                )
                            )
                            
                            TextField(
                                "Where is help needed?",
                                text: $location
                            )
                            .font(.system(size: 9))
                            .foregroundStyle(.black)
                        }
                        .padding(.horizontal, 12)
                        .frame(height: 45)
                        .background(.white)
                        .clipShape(
                            RoundedRectangle(
                                cornerRadius: 11
                            )
                        )
                        .padding(.top, 8)


                        // MARK: - Date

                        FormFieldTitle(
                            title: "Date (optional)"
                        )
                        .padding(.top, 17)

                        DatePicker(
                            "",
                            selection: $requestDate,
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
                            title: "Preferred Time (optional)"
                        )
                        .padding(.top, 17)
                        
                        HStack(spacing: 8) {
                            
                            Image(
                                systemName: "clock"
                            )
                            .font(.system(size: 10))
                            .foregroundStyle(
                                Color(
                                    red: 0.00,
                                    green: 0.55,
                                    blue: 0.45
                                )
                            )
                            
                            TextField(
                                "Example: Tomorrow, 9:00 AM",
                                text: $time
                            )
                            .font(.system(size: 9))
                            .foregroundStyle(.black)
                        }
                        .padding(.horizontal, 12)
                        .frame(height: 45)
                        .background(.white)
                        .clipShape(
                            RoundedRectangle(
                                cornerRadius: 11
                            )
                        )
                        .padding(.top, 8)
                        
                        
                        // MARK: - People Needed

                        FormFieldTitle(
                            title: "People Needed (optional)"
                        )
                        .padding(.top, 17)

                        HStack {

                            TextField(
                                "e.g. 1",
                                text: $peopleNeeded
                            )
                            .keyboardType(.numberPad)
                            .font(.system(size: 9))
                            .foregroundStyle(.black)

                            Text(
                                peopleNeeded == "1"
                                    ? "person"
                                    : "people"
                            )
                            .font(.system(size: 8))
                            .foregroundStyle(.gray)

                            Spacer()
                        }
                        .padding(.horizontal, 12)
                        .frame(height: 45)
                        .background(.white)
                        .clipShape(
                            RoundedRectangle(
                                cornerRadius: 11
                            )
                        )
                        .padding(.top, 8)
                        
                        
                        // MARK: - Post Button
                        
                        Button {
                            createRequest()
                        } label: {
                            
                            HStack(spacing: 8) {
                                
                                Image(
                                    systemName: "paperplane.fill"
                                )
                                
                                Text("Post Request")
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
                        .padding(.top, 23)
                        
                        Spacer(minLength: 30)
                    }
                    .padding(.horizontal, 20)
                }
            }
            .navigationTitle("Post a Request")
            .navigationBarTitleDisplayMode(.inline)
            .alert(
                "Unable to Post Request",
                isPresented: $showValidationAlert
            ) {
                
                Button("OK", role: .cancel) {
                    
                }
                
            } message: {

                Text(validationMessage)
            }
        }
    }


    // MARK: - Create Request
    
    private func createRequest() {
        
        let cleanTitle = title
            .trimmingCharacters(
                in: .whitespacesAndNewlines
            )
        
        let cleanDescription = description
            .trimmingCharacters(
                in: .whitespacesAndNewlines
            )
        
        let cleanLocation = location
            .trimmingCharacters(
                in: .whitespacesAndNewlines
            )
        
        let cleanTime = time
            .trimmingCharacters(
                in: .whitespacesAndNewlines
            )

        let cleanPeople = peopleNeeded
            .trimmingCharacters(
                in: .whitespacesAndNewlines
            )

        // MARK: Required fields

        guard !cleanTitle.isEmpty else {
            showValidation(
                "Please enter a title for your request."
            )
            return
        }

        guard !cleanDescription.isEmpty else {
            showValidation(
                "Please describe the help you need."
            )
            return
        }

        guard !cleanLocation.isEmpty else {
            showValidation(
                "Please enter the location."
            )
            return
        }

        // MARK: Optional fields

        // People Needed is optional — defaults to 1 when left blank,
        // but if the user types something, it must be a valid positive
        // number so it doesn't get passed to the model as garbage.
        var numberOfPeople = 1

        if !cleanPeople.isEmpty {

            guard
                let parsedPeople = Int(cleanPeople),
                parsedPeople > 0
            else {
                showValidation(
                    "People needed must be a valid number."
                )
                return
            }

            numberOfPeople = parsedPeople
        }

        controller.addRequest(
            title: cleanTitle,
            description: cleanDescription,
            category: selectedCategory,
            location: cleanLocation,
            date: requestDate,
            time: cleanTime,
            peopleNeeded: numberOfPeople,
            urgency: selectedUrgency
        )

        dismiss()
    }
    
    
    // MARK: - Validation
    
    private func showValidation(
        _ message: String
    ) {
        validationMessage = message
        showValidationAlert = true
    }
}


// MARK: - Form Field Title

struct FormFieldTitle: View {
    
    let title: String
    
    var body: some View {
        
        Text(title)
            .font(
                .system(
                    size: 10,
                    weight: .bold
                )
            )
            .foregroundStyle(.black)
    }
}


// MARK: - Preview

#Preview {
    
    PostRequestView()
        .environment(BayanihanController())
}
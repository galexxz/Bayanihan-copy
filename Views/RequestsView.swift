import SwiftUI

struct RequestsView: View {
    
    @Environment(BayanihanController.self) private var controller
    
    @State private var selectedCategory: RequestCategory? = nil
    @State private var selectedUrgency: RequestUrgency? = nil
    @State private var searchText = ""
    
    private var filteredRequests: [CommunityRequest] {
        
        controller.requests.filter { request in
            
            let matchesCategory =
                selectedCategory == nil ||
                request.category == selectedCategory
            
            let matchesUrgency =
                selectedUrgency == nil ||
                request.urgency == selectedUrgency
            
            let matchesSearch =
                searchText.trimmingCharacters(
                    in: .whitespacesAndNewlines
                ).isEmpty ||
                request.title.localizedCaseInsensitiveContains(searchText) ||
                request.description.localizedCaseInsensitiveContains(searchText) ||
                request.location.localizedCaseInsensitiveContains(searchText)
            
            return matchesCategory &&
                matchesUrgency &&
                matchesSearch &&
                request.status != .completed
        }
    }
    
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
                        
                        Text("Requests")
                            .font(
                                .system(
                                    size: 22,
                                    weight: .bold
                                )
                            )
                            .foregroundStyle(.black)
                            .padding(.top, 15)
                        
                        Text(
                            "Find someone in your community who needs help."
                        )
                        .font(.system(size: 9))
                        .foregroundStyle(.gray)
                        .padding(.top, 4)
                        
                        
                        // MARK: - Search
                        
                        HStack(spacing: 8) {
                            
                            Image(
                                systemName: "magnifyingglass"
                            )
                            .font(.system(size: 10))
                            .foregroundStyle(.gray)
                            
                            TextField(
                                "Search requests...",
                                text: $searchText
                            )
                            .font(.system(size: 9))
                            .foregroundStyle(.black)
                            
                            if !searchText.isEmpty {
                                
                                Button {
                                    searchText = ""
                                } label: {
                                    
                                    Image(
                                        systemName: "xmark.circle.fill"
                                    )
                                    .font(.system(size: 10))
                                    .foregroundStyle(.gray)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .padding(.horizontal, 12)
                        .frame(height: 43)
                        .background(.white)
                        .clipShape(
                            RoundedRectangle(
                                cornerRadius: 11
                            )
                        )
                        .padding(.top, 17)
                        
                        
                        // MARK: - Category Filter
                        
                        Text("Category")
                            .font(
                                .system(
                                    size: 10,
                                    weight: .bold
                                )
                            )
                            .foregroundStyle(.black)
                            .padding(.top, 17)
                        
                        ScrollView(
                            .horizontal,
                            showsIndicators: false
                        ) {
                            
                            HStack(spacing: 7) {
                                
                                FilterChip(
                                    title: "All",
                                    icon: "square.grid.2x2.fill",
                                    isSelected:
                                        selectedCategory == nil
                                ) {
                                    selectedCategory = nil
                                }
                                
                                ForEach(
                                    RequestCategory.allCases
                                ) { category in
                                    
                                    FilterChip(
                                        title: category.rawValue,
                                        icon: category.icon,
                                        isSelected:
                                            selectedCategory == category
                                    ) {
                                        selectedCategory = category
                                    }
                                }
                            }
                        }
                        .padding(.top, 8)
                        
                        
                        // MARK: - Urgency Filter
                        
                        Text("Urgency")
                            .font(
                                .system(
                                    size: 10,
                                    weight: .bold
                                )
                            )
                            .foregroundStyle(.black)
                            .padding(.top, 16)
                        
                        HStack(spacing: 7) {
                            
                            UrgencyFilterChip(
                                title: "All",
                                isSelected:
                                    selectedUrgency == nil
                            ) {
                                selectedUrgency = nil
                            }
                            
                            ForEach(
                                RequestUrgency.allCases
                            ) { urgency in
                                
                                UrgencyFilterChip(
                                    title: urgency.rawValue,
                                    isSelected:
                                        selectedUrgency == urgency
                                ) {
                                    selectedUrgency = urgency
                                }
                            }
                        }
                        .padding(.top, 8)
                        
                        
                        // MARK: - Results
                        
                        HStack {
                            
                            Text(
                                "\(filteredRequests.count) request\(filteredRequests.count == 1 ? "" : "s") found"
                            )
                            .font(
                                .system(
                                    size: 10,
                                    weight: .bold
                                )
                            )
                            .foregroundStyle(.black)
                            
                            Spacer()
                        }
                        .padding(.top, 22)
                        
                        
                        if filteredRequests.isEmpty {
                            
                            EmptyRequestsView(
                                searchText: searchText
                            )
                            .padding(.top, 35)
                            
                        } else {
                            
                            LazyVStack(
                                spacing: 10
                            ) {
                                
                                ForEach(
                                    filteredRequests
                                ) { request in
                                    
                                    NavigationLink {
                                        
                                        RequestDetailsView(
                                            request: request
                                        )
                                        
                                    } label: {
                                        
                                        CommunityRequestCard(
                                            request: request
                                        )
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                            .padding(.top, 10)
                        }
                        
                        Spacer(minLength: 30)
                    }
                    .padding(.horizontal, 20)
                }
            }
            .navigationTitle("Requests")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}


// MARK: - Community Request Card

struct CommunityRequestCard: View {
    
    let request: CommunityRequest
    
    var body: some View {
        
        VStack(
            alignment: .leading,
            spacing: 9
        ) {
            
            HStack(spacing: 10) {
                
                ZStack {
                    
                    RoundedRectangle(
                        cornerRadius: 10
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
                    .font(.system(size: 13))
                    .foregroundStyle(
                        Color(
                            red: 0.00,
                            green: 0.55,
                            blue: 0.45
                        )
                    )
                }
                .frame(
                    width: 43,
                    height: 43
                )
                
                VStack(
                    alignment: .leading,
                    spacing: 4
                ) {
                    
                    Text(
                        request.category.rawValue.uppercased()
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
                    
                    Text(request.title)
                        .font(
                            .system(
                                size: 10,
                                weight: .bold
                            )
                        )
                        .foregroundStyle(.black)
                        .lineLimit(2)
                }
                
                Spacer()
                
                UrgencyBadge(
                    urgency: request.urgency
                )
            }
            
            
            Text(request.description)
                .font(.system(size: 8))
                .foregroundStyle(.gray)
                .lineLimit(2)
            
            
            HStack(spacing: 12) {
                
                Label(
                    request.location,
                    systemImage: "mappin.and.ellipse"
                )
                
                Label(
                    request.time,
                    systemImage: "clock"
                )
                
                Spacer()
            }
            .font(.system(size: 7))
            .foregroundStyle(.gray)
            
            
            HStack {
                
                HStack(spacing: 5) {
                    
                    Image(
                        systemName: "person.circle.fill"
                    )
                    .font(.system(size: 8))
                    
                    Text(request.requesterName)
                        .font(.system(size: 7))
                }
                
                Spacer()
                
                Text(
                    request.peopleNeeded == 1
                        ? "1 person needed"
                        : "\(request.peopleNeeded) people needed"
                )
                .font(
                    .system(
                        size: 7,
                        weight: .semibold
                    )
                )
            }
            .foregroundStyle(.gray)
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


// MARK: - Filter Chip

struct FilterChip: View {
    
    let title: String
    let icon: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        
        Button {
            action()
        } label: {
            
            HStack(spacing: 5) {
                
                Image(systemName: icon)
                    .font(.system(size: 8))
                
                Text(title)
                    .font(
                        .system(
                            size: 8,
                            weight: .semibold
                        )
                    )
            }
            .foregroundStyle(
                isSelected
                    ? .white
                    : .black
            )
            .padding(.horizontal, 10)
            .frame(height: 31)
            .background(
                isSelected
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


// MARK: - Urgency Filter Chip

struct UrgencyFilterChip: View {
    
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        
        Button {
            action()
        } label: {
            
            Text(title)
                .font(
                    .system(
                        size: 8,
                        weight: .semibold
                    )
                )
                .foregroundStyle(
                    isSelected
                        ? .white
                        : .black
                )
                .padding(.horizontal, 11)
                .frame(height: 31)
                .background(
                    isSelected
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


// MARK: - Urgency Badge

struct UrgencyBadge: View {
    
    let urgency: RequestUrgency
    
    var body: some View {
        
        Text(
            urgency.rawValue.uppercased()
        )
        .font(
            .system(
                size: 6,
                weight: .bold
            )
        )
        .foregroundStyle(urgencyColor)
        .padding(.horizontal, 7)
        .padding(.vertical, 5)
        .background(
            urgencyColor.opacity(0.10)
        )
        .clipShape(Capsule())
    }
    
    private var urgencyColor: Color {
        
        switch urgency {
        case .normal:
            return Color(
                red: 0.00,
                green: 0.55,
                blue: 0.45
            )
            
        case .urgent:
            return .orange
            
        case .emergency:
            return .red
        }
    }
}


// MARK: - Empty Requests

struct EmptyRequestsView: View {
    
    let searchText: String
    
    var body: some View {
        
        VStack(spacing: 10) {
            
            Image(
                systemName: searchText.isEmpty
                    ? "hands.sparkles"
                    : "magnifyingglass"
            )
            .font(.system(size: 32))
            .foregroundStyle(
                .gray.opacity(0.45)
            )
            
            Text(
                searchText.isEmpty
                    ? "No Requests Available"
                    : "No Matching Requests"
            )
            .font(
                .system(
                    size: 14,
                    weight: .bold
                )
            )
            .foregroundStyle(.black)
            
            Text(
                searchText.isEmpty
                    ? "New community help requests will appear here."
                    : "Try a different search or filter."
            )
            .font(.system(size: 9))
            .foregroundStyle(.gray)
            .multilineTextAlignment(.center)
            .padding(.horizontal, 30)
        }
        .frame(
            maxWidth: .infinity
        )
    }
}


// MARK: - Preview

#Preview {
    
    RequestsView()
        .environment(BayanihanController())
}
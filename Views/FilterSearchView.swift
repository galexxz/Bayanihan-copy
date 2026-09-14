import SwiftUI

struct FilterSearchView: View {

    @Environment(\.dismiss) private var dismiss

    @Binding var selectedCategory: RequestCategory?
    @Binding var selectedSort: RequestSort

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

                    // MARK: - Category

                    Text("Filter by Category")
                        .font(
                            .system(
                                size: 13,
                                weight: .bold
                            )
                        )
                        .foregroundStyle(.black)
                        .padding(.top, 15)

                    LazyVGrid(
                        columns: [
                            GridItem(.flexible()),
                            GridItem(.flexible())
                        ],
                        spacing: 8
                    ) {

                        FilterChip(
                            title: "All",
                            icon: "square.grid.2x2.fill",
                            isSelected:
                                selectedCategory == nil
                        ) {
                            selectedCategory = nil
                        }
                        .frame(maxWidth: .infinity)

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
                            .frame(maxWidth: .infinity)
                        }
                    }
                    .padding(.top, 12)


                    // MARK: - Sort

                    Text("Sort by")
                        .font(
                            .system(
                                size: 13,
                                weight: .bold
                            )
                        )
                        .foregroundStyle(.black)
                        .padding(.top, 24)

                    VStack(spacing: 9) {

                        ForEach(
                            RequestSort.allCases
                        ) { sort in

                            Button {
                                selectedSort = sort
                            } label: {

                                HStack {

                                    Text(sort.rawValue)
                                        .font(
                                            .system(
                                                size: 10,
                                                weight: .semibold
                                            )
                                        )
                                        .foregroundStyle(.black)

                                    Spacer()

                                    if selectedSort == sort {

                                        Image(
                                            systemName: "checkmark"
                                        )
                                        .font(
                                            .system(
                                                size: 10,
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
                                .padding(.horizontal, 14)
                                .frame(height: 48)
                                .background(
                                    selectedSort == sort
                                        ? Color(
                                            red: 0.00,
                                            green: 0.55,
                                            blue: 0.45
                                        ).opacity(0.08)
                                        : Color.white
                                )
                                .clipShape(
                                    RoundedRectangle(
                                        cornerRadius: 11
                                    )
                                )
                                .overlay {

                                    if selectedSort == sort {

                                        RoundedRectangle(
                                            cornerRadius: 11
                                        )
                                        .stroke(
                                            Color(
                                                red: 0.00,
                                                green: 0.55,
                                                blue: 0.45
                                            ),
                                            lineWidth: 1
                                        )
                                    }
                                }
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.top, 8)


                    // MARK: - Apply

                    Button {
                        dismiss()
                    } label: {

                        Text("Apply Filters")
                            .font(
                                .system(
                                    size: 11,
                                    weight: .bold
                                )
                            )
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
        .navigationTitle("Filter & Search")
        .navigationBarTitleDisplayMode(.inline)
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


// MARK: - Request Sort

enum RequestSort: String, CaseIterable, Identifiable {

    case newest = "Newest"
    case oldest = "Oldest"
    case urgentFirst = "Urgent First"

    var id: String {
        rawValue
    }
}


// MARK: - Preview

#Preview {

    NavigationStack {

        FilterSearchView(
            selectedCategory: .constant(nil),
            selectedSort: .constant(.newest)
        )
    }
}

//
//  FuelNameDropdown.swift
//  car-journal
//
//  Created by Rayendra Timotius Sabandar on 29/03/26.
//

import SwiftUI

struct FuelNameDropdown: View {
    @Binding var fuelName: String
    @Binding var fuelType: String
    @Binding var fuelBrand: String
    @Binding var fuelPrice: String
    @State private var suggestions: [FuelListResponse] = []
    @State private var showDropdown = false
    var viewModel: FuelEntryViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Search field
            HStack(spacing: 10) {
                Image(systemName: "magnifyingglass")
                    .font(.appSubheadline)
                    .foregroundStyle(Color.cjTextSecondary)
                    .onTapGesture { performSearch() }

                TextField("Search fuel name", text: $fuelName)
                    .font(.appBody)
                    .foregroundStyle(Color.cjTextPrimary)
                    .autocapitalization(.none)
                    .onSubmit { performSearch() }

                Spacer()

                Button {
                    showDropdown.toggle()
                } label: {
                    Image(systemName: showDropdown ? "chevron.up" : "chevron.down")
                        .font(.appCaption)
                        .foregroundStyle(Color.cjTextSecondary)
                }
            }
            .appInput()

            // Dropdown results
            if showDropdown && !suggestions.isEmpty {
                VStack(alignment: .leading, spacing: 0) {
                    ForEach(suggestions, id: \.id) { suggestion in
                        Button {
                            showDropdown = false
                            fuelName = suggestion.name
                            fuelType = suggestion.type
                            fuelBrand = suggestion.brand
                            fuelPrice = DecimalFormatter.number(suggestion.price)
                        } label: {
                            VStack(alignment: .leading, spacing: 2) {
                                Text(suggestion.name)
                                    .font(.appSubheadline)
                                    .fontWeight(.medium)
                                    .foregroundStyle(Color.cjTextPrimary)
                                Text("\(suggestion.brand) · \(suggestion.type)")
                                    .font(.appCaption)
                                    .foregroundStyle(Color.cjTextSecondary)
                            }
                            .padding(.horizontal, 14)
                            .padding(.vertical, 10)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        .buttonStyle(.plain)

                        if suggestion.id != suggestions.last?.id {
                            Divider().padding(.leading, 14)
                        }
                    }
                }
                .background(Color.cjSurface)
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                .shadow(color: Color.appDark.opacity(0.12), radius: 8, x: 0, y: 4)
                .frame(maxHeight: 180)
                .padding(.top, 4)
            }
        }
        .animation(.easeInOut(duration: 0.2), value: showDropdown)
        .animation(.easeInOut(duration: 0.2), value: suggestions.count)
    }

    private func performSearch() {
        Task {
            await viewModel.listFuel(name: fuelName, page: 1)
            await MainActor.run {
                suggestions = viewModel.fuels
                showDropdown = true
            }
        }
    }
}

#Preview {
    @Previewable @State var selectedFuelName = ""
    @Previewable @State var fuelType = ""
    @Previewable @State var fuelBrand = ""
    @Previewable @State var fuelPrice = ""
    let mockViewModel = MockFuelEntryViewModel()

    ZStack {
        Color.cjBackground.ignoresSafeArea()
        FuelNameDropdown(
            fuelName: $selectedFuelName,
            fuelType: $fuelType,
            fuelBrand: $fuelBrand,
            fuelPrice: $fuelPrice,
            viewModel: mockViewModel
        )
        .padding()
    }
}

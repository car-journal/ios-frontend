//
//  FuelNameDropdown.swift
//  car-journal
//
//  Created by Rayendra Timotius Sabandar on 29/03/26.
//

import SwiftUI

struct FuelNameDropdown: View {
    @Binding var fuelName: String
    @State private var suggestions: [FuelListResponse] = []
    @State private var showDropdown = false
    var viewModel: FuelEntryViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                
            }
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundStyle(.secondary)
                    .onTapGesture {
                        Task {
                            await viewModel.listFuel(name: fuelName, page: 1)
                            await MainActor.run {
                                suggestions = viewModel.fuels
                                showDropdown = true
                            }
                        }
                    }

                TextField("Fuel Name", text: $fuelName)
                    .autocapitalization(.none)
                    .onSubmit {
                        Task {
                            await viewModel.listFuel(name: fuelName, page: 1)
                            await MainActor.run {
                                suggestions = viewModel.fuels
                                showDropdown = true
                            }
                        }
                    }

                Spacer()

                Image(systemName: showDropdown ? "chevron.up" : "chevron.down")
                    .foregroundStyle(.secondary)
                    .onTapGesture {
                        showDropdown.toggle()
                    }
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(10)
            
            if showDropdown && !suggestions.isEmpty {
                ScrollView {
                    VStack(alignment: .leading, spacing: 0) {
                        ForEach(suggestions, id: \.id) { suggestion in
                            Text(suggestion.name)
                                .padding()
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(Color.white)
                                .onTapGesture {
                                    showDropdown = false
                                    fuelName = suggestion.name
                                    viewModel.fuelType = suggestion.type
                                    viewModel.fuelBrand = suggestion.brand
                                    viewModel.fuelPrice = DecimalFormatter.number(suggestion.price)
                                }
                            Divider()
                        }
                    }
                }
                .frame(maxHeight: 150)
                .background(Color.white)
                .cornerRadius(10)
                .shadow(radius: 5)
            }
        }
        .animation(.default, value: suggestions)
    }
}

#Preview {
    @Previewable @State var selectedFuelName = ""
    let mockViewModel = MockFuelEntryViewModel()
    
    NavigationStack {
        FuelNameDropdown(fuelName: $selectedFuelName, viewModel: mockViewModel)
            .padding()
    }
}

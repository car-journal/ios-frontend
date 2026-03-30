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
            TextField("Fuel Name", text: $fuelName)
            .autocapitalization(.none)
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(10)
//            .onChange(of: fuelName) { _, newValue in
//                print("newValue:", newValue)
//                Task {
//                    await viewModel.listFuel(name: newValue)
//                    suggestions = viewModel.fuelNames
//                    showDropdown = true
//                }
//            }
            .onSubmit {
                Task {
                    await viewModel.listFuel(name: fuelName, page: 1)
                    suggestions = viewModel.fuels
                    showDropdown = true
                }
            }
            
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
    @State var selectedFuelName = ""
    let mockViewModel = MockFuelEntryViewModel()
    
    NavigationStack {
        FuelNameDropdown(fuelName: $selectedFuelName, viewModel: mockViewModel)
            .padding()
    }
}

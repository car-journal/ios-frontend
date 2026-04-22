//
//  CategoryPickerField.swift
//  car-journal
//

import SwiftUI

struct CategoryPickerField: View {
    @Binding var selectedID: String
    @Binding var selectedName: String
    let categories: [MaintenanceCategoryResponse]
    let isLoading: Bool

    var body: some View {
        Menu {
            if isLoading {
                Text("Loading categories...")
            } else {
                ForEach(categories) { cat in
                    Button {
                        selectedID = cat.id.uuidString
                        selectedName = cat.name
                    } label: {
                        HStack {
                            Text(cat.name)
                            if selectedID == cat.id.uuidString {
                                Image(systemName: "checkmark")
                            }
                        }
                    }
                }
            }
        } label: {
            HStack {
                Text(selectedName.isEmpty ? "Select Category" : selectedName)
                    .font(.appBody)
                    .foregroundStyle(selectedName.isEmpty ? Color.cjTextSecondary : Color.cjTextPrimary)
                Spacer()
                Image(systemName: "chevron.up.chevron.down")
                    .font(.appCaption)
                    .foregroundStyle(Color.cjTextSecondary)
            }
            .appInput()
        }
    }
}

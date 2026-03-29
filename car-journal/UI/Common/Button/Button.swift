//
//  Button.swift
//  car-journal
//
//  Created by Rayendra Timotius Sabandar on 29/03/26.
//

import SwiftUI

struct AppButton: View {
    let title: String
    let isLoading: Bool
    let isDisabled: Bool
    let action: () async -> Void
    
    init(
        title: String,
        isLoading: Bool = false,
        isDisabled: Bool = false,
        action: @escaping () async -> Void
    ) {
        self.title = title
        self.isLoading = isLoading
        self.isDisabled = isDisabled
        self.action = action
    }
    
    var body: some View {
        Button {
            Task {
                await action()
            }
        } label: {
            ZStack {
                    if isLoading {
                        ProgressView()
                            .progressViewStyle(.circular)
                            .tint(.white)
                    } else {
                        Text(title)
                            .fontWeight(.semibold)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(isLoading ? Color.gray : Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
        .disabled(isLoading || isDisabled)
    }
}

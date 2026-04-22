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

    private var isInactive: Bool { isLoading || isDisabled }

    private var labelColor: Color { isInactive ? Color.cjTextSecondary : Color.cjOnPrimary }
    private var bgColor: Color    { isInactive ? Color.cjSurfaceSecondary : Color.cjPrimary }

    var body: some View {
        Button {
            Task { await action() }
        } label: {
            ZStack {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(.circular)
                        .tint(Color.cjOnPrimary)
                } else {
                    Text(title)
                        .font(.appHeadline)
                        .foregroundStyle(labelColor)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .background(
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .fill(bgColor)
            )
        }
        .disabled(isInactive)
        .animation(.easeInOut(duration: 0.15), value: isInactive)
    }
}

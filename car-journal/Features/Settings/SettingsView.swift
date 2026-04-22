//
//  SettingsView.swift
//  car-journal
//
//  Created by Kiro on 22/04/26.
//

import SwiftUI

struct SettingsView: View {
    @ObservedObject private var themeManager = ThemeManager.shared
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ZStack {
                Color.cjBackground.ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 24) {
                        themeSection
                    }
                    .padding(20)
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(Color.cjBackground, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { dismiss() }
                        .font(.appSubheadline)
                        .foregroundStyle(Color.cjPrimary)
                }
            }
        }
    }

    // MARK: - Theme section
    private var themeSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 6) {
                Image(systemName: "paintbrush.fill")
                    .font(.appSubheadline)
                    .foregroundStyle(Color.appShade2)
                Text("Appearance")
                    .font(.appHeadline)
                    .foregroundStyle(Color.cjTextPrimary)
            }
            .padding(.leading, 4)

            VStack(spacing: 0) {
                ForEach(AppThemeMode.allCases, id: \.rawValue) { mode in
                    themeRow(mode)

                    if mode != AppThemeMode.allCases.last {
                        Divider()
                            .padding(.leading, 52)
                            .opacity(0.5)
                    }
                }
            }
            .appCard()
        }
    }

    private func themeRow(_ mode: AppThemeMode) -> some View {
        Button {
            themeManager.set(mode)
        } label: {
            HStack(spacing: 14) {
                // Icon badge
                Image(systemName: mode.icon)
                    .font(.appSubheadline)
                    .foregroundStyle(themeManager.mode == mode ? Color.cjOnPrimary : Color.appShade2)
                    .frame(width: 32, height: 32)
                    .background(
                        RoundedRectangle(cornerRadius: 8, style: .continuous)
                            .fill(themeManager.mode == mode ? Color.cjPrimary : Color.appShade1.opacity(0.12))
                    )

                Text(mode.label)
                    .font(.appBody)
                    .foregroundStyle(Color.cjTextPrimary)

                Spacer()

                if themeManager.mode == mode {
                    Image(systemName: "checkmark")
                        .font(.appSubheadline)
                        .fontWeight(.semibold)
                        .foregroundStyle(Color.cjPrimary)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    SettingsView()
}

//
//  ThemeManager.swift
//  car-journal
//
//  Created by Kiro on 22/04/26.
//

import SwiftUI
import Combine

enum AppThemeMode: String, CaseIterable {
    case system = "system"
    case light  = "light"
    case dark   = "dark"

    var label: String {
        switch self {
        case .system: return "System Default"
        case .light:  return "Light"
        case .dark:   return "Dark"
        }
    }

    var icon: String {
        switch self {
        case .system: return "circle.lefthalf.filled"
        case .light:  return "sun.max.fill"
        case .dark:   return "moon.fill"
        }
    }

    /// Maps to SwiftUI's ColorScheme preference (nil = follow system)
    var colorScheme: ColorScheme? {
        switch self {
        case .system: return nil
        case .light:  return .light
        case .dark:   return .dark
        }
    }
}

final class ThemeManager: ObservableObject {
    static let shared = ThemeManager()

    private static let key = "cj_theme_mode"

    @Published private(set) var mode: AppThemeMode {
        didSet {
            UserDefaults.standard.set(mode.rawValue, forKey: Self.key)
        }
    }

    private init() {
        let saved = UserDefaults.standard.string(forKey: Self.key) ?? ""
        mode = AppThemeMode(rawValue: saved) ?? .system
    }

    func set(_ mode: AppThemeMode) {
        self.mode = mode
    }
}

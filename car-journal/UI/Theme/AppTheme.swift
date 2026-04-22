//
//  AppTheme.swift
//  car-journal
//
//  Created by Kiro on 22/04/26.
//

import SwiftUI
import UIKit

// MARK: - Color Palette
//
// Philosophy: deep navy dark theme, warm off-white light theme.
//
// Light mode                 Dark mode
// Background:  #F0EBE3       #0D1B2A   (warm off-white / deep navy)
// Surface:     #FAFAF8       #132337   (near-white / slightly lighter navy)
// Surface 2:   #E8E2D9       #0D1B2A   (muted off-white / same as bg for inputs)
// Primary:     #1B4F72       #2E86AB   (rich navy / bright teal-blue)
// On Primary:  #FAFAF8       #F0EBE3   (light text on primary buttons)
// Text Pri:    #0D1B2A       #EEF2F7   (near-black / near-white)
// Text Sec:    #4A6FA5       #7BAFD4   (muted blue / lighter blue)
// Positive:    #1E7A4A       #3DBE7A   (deep green / bright green — readable on both)
// Negative:    #C0392B       #E74C3C   (dark red on light / bright red on dark)
// Shade 1:     #1B4F72       (rich navy — used for icons, accents)
// Shade 2:     #2E86AB       (teal-blue — used for secondary accents)

// MARK: - Hex initialiser (UIColor)
private extension UIColor {
    convenience init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3:
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6:
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            red:   CGFloat(r) / 255,
            green: CGFloat(g) / 255,
            blue:  CGFloat(b) / 255,
            alpha: CGFloat(a) / 255
        )
    }

    static func adaptive(light: String, dark: String) -> UIColor {
        UIColor { traits in
            traits.userInterfaceStyle == .dark
                ? UIColor(hex: dark)
                : UIColor(hex: light)
        }
    }
}

// MARK: - Color extensions
extension Color {
    // MARK: Fixed brand colours (same in both modes — used for gradients, icons)
    static let appDark     = Color(hex: "0D1B2A")   // deep navy
    static let appLight    = Color(hex: "F0EBE3")   // warm off-white
    static let appShade1   = Color(hex: "1B4F72")   // rich navy blue
    static let appShade2   = Color(hex: "2E86AB")   // teal-blue

    // MARK: Semantic — adaptive (cj prefix avoids Xcode asset symbol clash)
    static let appPositive = Color(uiColor: .adaptive(light: "1E7A4A", dark: "3DBE7A"))
    static let appNegative = Color(uiColor: .adaptive(light: "C0392B", dark: "E74C3C"))

    static let cjBackground       = Color(uiColor: .adaptive(light: "F0EBE3", dark: "0D1B2A"))
    static let cjSurface          = Color(uiColor: .adaptive(light: "FAFAF8", dark: "132337"))
    static let cjSurfaceSecondary = Color(uiColor: .adaptive(light: "E8E2D9", dark: "0D1B2A"))
    static let cjPrimary          = Color(uiColor: .adaptive(light: "1B4F72", dark: "2E86AB"))
    static let cjOnPrimary        = Color(uiColor: .adaptive(light: "FAFAF8", dark: "F0EBE3"))
    static let cjTextPrimary      = Color(uiColor: .adaptive(light: "0D1B2A", dark: "EEF2F7"))
    static let cjTextSecondary    = Color(uiColor: .adaptive(light: "4A6FA5", dark: "7BAFD4"))
}

// MARK: - Hex initialiser (Color)
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3:
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6:
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red:     Double(r) / 255,
            green:   Double(g) / 255,
            blue:    Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

// MARK: - Typography
extension Font {
    static let appLargeTitle   = Font.system(size: 32, weight: .bold,     design: .rounded)
    static let appTitle        = Font.system(size: 22, weight: .bold,     design: .rounded)
    static let appTitle2       = Font.system(size: 18, weight: .semibold, design: .rounded)
    static let appHeadline     = Font.system(size: 16, weight: .semibold, design: .rounded)
    static let appBody         = Font.system(size: 15, weight: .regular,  design: .rounded)
    static let appSubheadline  = Font.system(size: 13, weight: .regular,  design: .rounded)
    static let appCaption      = Font.system(size: 11, weight: .regular,  design: .rounded)
}

// MARK: - Reusable view modifiers
struct AppCardModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(Color.cjSurface)
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            .shadow(color: Color.appDark.opacity(0.12), radius: 10, x: 0, y: 4)
    }
}

struct AppInputModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(.horizontal, 14)
            .padding(.vertical, 12)
            .background(Color.cjSurfaceSecondary)
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
    }
}

extension View {
    func appCard() -> some View { modifier(AppCardModifier()) }
    func appInput() -> some View { modifier(AppInputModifier()) }
}

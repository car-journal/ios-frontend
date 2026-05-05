//
//  AppConfig.swift
//  car-journal
//
//  Reads build-time configuration values injected via xcconfig → Info.plist.
//  Never hardcode secrets in Swift source files.
//

import Foundation

enum AppConfig {
    // MARK: - Base URL
    static let baseURL: URL = {
        // 1. Try Info.plist (xcconfig injection — preferred for all environments)
        if let raw = Bundle.main.object(forInfoDictionaryKey: "BASE_URL") as? String,
           !raw.isEmpty,
           !raw.hasPrefix("$("),          // guard against unexpanded xcconfig variable
           let url = URL(string: raw) {
            return url
        }
        // 2. Fallback for development before xcconfig is wired up in Xcode
        #if DEBUG
        let fallback = "https://dev-carjournal.gudegmartinah.my.id"
        print("⚠️ AppConfig: BASE_URL not found in Info.plist — using DEBUG fallback: \(fallback)")
        return URL(string: fallback)!
        #else
        fatalError("BASE_URL is missing or invalid in Info.plist. Add it via xcconfig → Info.plist.")
        #endif
    }()

    // MARK: - Client Secret
    static let clientSecret: String = {
        // 1. Try Info.plist
        if let secret = Bundle.main.object(forInfoDictionaryKey: "CLIENT_SECRET") as? String,
           !secret.isEmpty,
           !secret.hasPrefix("$(") {
            return secret
        }
        // 2. Fallback for development
        #if DEBUG
        let fallback = "local_secret"
        print("⚠️ AppConfig: CLIENT_SECRET not found in Info.plist — using DEBUG fallback.")
        return fallback
        #else
        fatalError("CLIENT_SECRET is missing in Info.plist. Add it via xcconfig → Info.plist.")
        #endif
    }()
}

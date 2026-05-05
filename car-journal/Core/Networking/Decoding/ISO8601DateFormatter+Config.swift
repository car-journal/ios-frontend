//
//  ISO8601DateFormatter+Config.swift
//  car-journal
//
//  Created by Rayendra Timotius Sabandar on 25/03/26.
//

import Foundation

extension ISO8601DateFormatter {
    /// With fractional seconds: "2026-04-08T00:03:41.339246+07:00"
    static let backend: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [
            .withInternetDateTime,
            .withFractionalSeconds,
            .withTimeZone
        ]
        return formatter
    }()

    /// Without fractional seconds: "2026-04-06T15:44:00+07:00"
    static let backendNoFraction: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [
            .withInternetDateTime,
            .withTimeZone
        ]
        return formatter
    }()
}

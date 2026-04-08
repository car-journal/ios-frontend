//
//  DateFormatter.swift
//  car-journal
//
//  Created by Rayendra Timotius Sabandar on 07/04/26.
//

import Foundation

struct DateFormatterUtils {
    private static let displayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM yyyy"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()
    
    static func format(_ date: Date) -> String {
        return displayFormatter.string(from: date)
    }
}

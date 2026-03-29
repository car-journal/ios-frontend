//
//  DecimalFormatter.swift
//  car-journal
//
//  Created by Rayendra Timotius Sabandar on 29/03/26.
//

import Foundation

struct DecimalFormatter {
    // TODO: set the locale as a global variable for anything needed locale
    static let locale = Locale(identifier: "en_US_POSIX")
    
    static func number(_ value: Double, fractionLength: Int = 2) -> String {
        value.formatted(
            .number
                .precision(.fractionLength(fractionLength))
                .locale(locale)
        )
    }
    
    static func rounded(_ value: Double, fractionLength: Int = 2) -> Double {
        let multiplier = pow(10.0, Double(fractionLength))
        return (value * multiplier).rounded() / multiplier
    }
}

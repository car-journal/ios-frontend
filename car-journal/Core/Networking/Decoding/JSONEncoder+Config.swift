//
//  JSONEncoder+Config.swift
//  car-journal
//
//  Created by Rayendra Timotius Sabandar on 29/03/26.
//

import Foundation

enum DateEncodingStrategyType {
    case iso8601
    case unix
}

extension JSONEncoder {
    static func apiEncoder(dateStrategy: DateEncodingStrategyType = .iso8601) -> JSONEncoder {
        let encoder = JSONEncoder()
        
        encoder.keyEncodingStrategy = .convertToSnakeCase
        
        encoder.dateEncodingStrategy = .custom { date, encoder in
            var container = encoder.singleValueContainer()
            
            switch dateStrategy {
            case .unix:
                // 1. Encode as unix timestamp
                try container.encode(date.timeIntervalSince1970)
                
            case .iso8601:
                // 2. Encode as ISO8601 string
                try container.encode(
                    ISO8601DateFormatter.backend.string(from: date)
                )
            }
        }
        
        return encoder
    }
}

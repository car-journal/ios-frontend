//
//  JSONDecoder+Config.swift
//  car-journal
//
//  Created by Rayendra Timotius Sabandar on 25/03/26.
//

import Foundation

extension JSONDecoder {
    static var apiDecoder: JSONDecoder {
        let decoder = JSONDecoder()
        
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .custom { decoder in
            let container = try decoder.singleValueContainer()

            // 1. Try unix timestamp
            if let timestamp = try? container.decode(Double.self) {
                return Date(timeIntervalSince1970: timestamp)
            }

            // 2. Try ISO8601 with fractional seconds: "2026-04-08T00:03:41.339246+07:00"
            // Then without: "2026-04-06T15:44:00+07:00"
            if let dateString = try? container.decode(String.self) {
                if let date = ISO8601DateFormatter.backend.date(from: dateString) {
                    return date
                }
                if let date = ISO8601DateFormatter.backendNoFraction.date(from: dateString) {
                    return date
                }
            }

            throw DecodingError.dataCorruptedError(
                in: container,
                debugDescription: "Invalid date format"
            )
        }
        
        return decoder
    }
}

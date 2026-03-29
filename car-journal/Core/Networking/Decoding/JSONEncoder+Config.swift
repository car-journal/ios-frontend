//
//  JSONEncoder+Config.swift
//  car-journal
//
//  Created by Rayendra Timotius Sabandar on 29/03/26.
//

import Foundation

extension JSONEncoder {
    static var apiEncoder: JSONEncoder {
        let encoder = JSONEncoder()
        
        encoder.keyEncodingStrategy = .convertToSnakeCase
        encoder.dateEncodingStrategy = .custom { date, encoder in
            var container = encoder.singleValueContainer()
            
            // send as unix timestamp (matches your decoder support)
            try container.encode(date.timeIntervalSince1970)
        }
        
        return encoder
    }
}

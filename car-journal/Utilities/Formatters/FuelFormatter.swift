//
//  FuelFormatter.swift
//  car-journal
//
//  Created by Rayendra Timotius Sabandar on 27/03/26.
//

import Foundation

struct Formatter {
    static func kmPerLiter(_ value: Double) -> String {
        DecimalFormatter.number(value, fractionLength: 2) + " Km/L"
    }
    
    static func volumeLiter(_ value: Double) -> String {
        DecimalFormatter.number(value, fractionLength: 2) + " L"
    }
    
    static func distanceTravelledKm(_ value: Double) -> String {
        DecimalFormatter.number(value, fractionLength: 2) + " Km"
    }
}

//
//  CarCreateRequest.swift
//  car-journal
//

import Foundation

struct CarCreateRequest: Encodable {
    let brand: String
    let model: String
    let manufactureYear: Int
    let cylinderCapacity: Int
    let vehicleIdentityNumber: String?
    let engineNumber: String?
    let color: String?
    let fuelType: String
    let registrationYear: String?
    let vehicleOwnershipDocumentNumber: String?
}

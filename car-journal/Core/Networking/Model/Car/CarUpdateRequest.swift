//
//  CarUpdateRequest.swift
//  car-journal
//
//  Created by Rayendra Timotius Sabandar on 01/04/26.
//

import Foundation

struct CarUpdateRequest: Encodable {
    let brand: String
    let model: String
    let manufactureYear: Int
    let cylinderCapacity: Int
    let vehicleIdentityNumber: String?
    let engineNumber: String?
    let color: String?
    let fuelType: String
    let registrationYear: String?
    let vehicleOwnershipDocumentNumber: String
}

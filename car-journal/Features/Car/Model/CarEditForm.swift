//
//  CarEditForm.swift
//  car-journal
//
//  Created by Kiro on 21/04/26.
//

import Foundation

struct CarEditForm {
    var brand: String = ""
    var model: String = ""
    var manufactureYear: String = ""
    var cylinderCapacity: String = ""
    var vehicleIdentityNumber: String = ""
    var engineNumber: String = ""
    var color: String = ""
    var fuelType: String = ""
    var registrationYear: String = ""
    var vehicleOwnershipDocumentNumber: String = ""
}

extension CarEditForm {
    init(from response: CarDetailResponse) {
        self.brand = response.brand
        self.model = response.model
        self.manufactureYear = String(response.manufactureYear)
        self.cylinderCapacity = String(response.cylinderCapacity)
        self.vehicleIdentityNumber = response.vehicleIdentityNumber ?? ""
        self.engineNumber = response.engineNumber ?? ""
        self.color = response.color
        self.fuelType = response.fuelType
        self.registrationYear = response.registrationYear ?? ""
        self.vehicleOwnershipDocumentNumber = response.vehicleOwnershipDocumentNumber ?? ""
    }
}

extension CarEditForm {
    func validate() -> String? {
        if brand.trimmingCharacters(in: .whitespaces).isEmpty {
            return "Brand is required"
        }
        if model.trimmingCharacters(in: .whitespaces).isEmpty {
            return "Model is required"
        }
        if color.trimmingCharacters(in: .whitespaces).isEmpty {
            return "Color is required"
        }
        if fuelType.trimmingCharacters(in: .whitespaces).isEmpty {
            return "Fuel type is required"
        }
        guard let year = Int(manufactureYear), year > 0 else {
            return "Manufacture year must be a positive number"
        }
        guard let capacity = Int(cylinderCapacity), capacity > 0 else {
            return "Cylinder capacity must be a positive number"
        }
        return nil
    }
}

extension CarEditForm {
    func toUpdateRequest() -> CarUpdateRequest {
        CarUpdateRequest(
            brand: brand,
            model: model,
            manufactureYear: Int(manufactureYear) ?? 0,
            cylinderCapacity: Int(cylinderCapacity) ?? 0,
            vehicleIdentityNumber: vehicleIdentityNumber.isEmpty ? nil : vehicleIdentityNumber,
            engineNumber: engineNumber.isEmpty ? nil : engineNumber,
            color: color.isEmpty ? nil : color,
            fuelType: fuelType,
            registrationYear: registrationYear.isEmpty ? nil : registrationYear,
            vehicleOwnershipDocumentNumber: vehicleOwnershipDocumentNumber
        )
    }

    func toCreateRequest() -> CarCreateRequest {
        CarCreateRequest(
            brand: brand,
            model: model,
            manufactureYear: Int(manufactureYear) ?? 0,
            cylinderCapacity: Int(cylinderCapacity) ?? 0,
            vehicleIdentityNumber: vehicleIdentityNumber.isEmpty ? nil : vehicleIdentityNumber,
            engineNumber: engineNumber.isEmpty ? nil : engineNumber,
            color: color.isEmpty ? nil : color,
            fuelType: fuelType,
            registrationYear: registrationYear.isEmpty ? nil : registrationYear,
            vehicleOwnershipDocumentNumber: vehicleOwnershipDocumentNumber.isEmpty ? nil : vehicleOwnershipDocumentNumber
        )
    }
}

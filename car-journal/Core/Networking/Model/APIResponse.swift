//
//  APIResponse.swift
//  car-journal
//
//  Created by Rayendra Timotius Sabandar on 25/03/26.
//

import Foundation

struct APIResponse<T: Decodable>: Decodable {
    let data: T
}

struct PaginatedResponse<T: Decodable>: Decodable {
    let data: [T]
    let meta: PaginationMeta
}

struct PaginationMeta: Decodable {
    let affectedRecords: Int
    let lastPage: Int
    let count: Int
    let hasNext: Bool
}

struct MutationResponse: Decodable {
    let success: Bool
}

struct APIErrorResponse: Decodable {
    let success: Bool
    let error: APIError
}

struct APIError: Decodable, Error {
    let type: String
    let message: String
    let raw: String?
}

//
//  CarEndpoint.swift
//  car-journal
//
//  Created by Rayendra Timotius Sabandar on 25/03/26.
//

import Foundation

enum FuelEndpoint: Endpoint {
    case list(name: String, page: Int, limit: Int, token: String)
}

extension FuelEndpoint {
    var path: String {
        switch self {
        case .list:
            return "/v1/internal/fuels"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .list:
            return .get
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case let .list(_, _, _, token):
            return [
                "Authorization": "Bearer \(token)"
            ]
        }
    }
    
    var body: (any Encodable)? {
        nil
    }
    
    var queryItems: [URLQueryItem]? {
        switch self {
        case let .list(name, page, limit, _):
            return [
                URLQueryItem(name: "name", value: "\(name)"),
                URLQueryItem(name: "page", value: "\(page)"),
                URLQueryItem(name: "limit", value: "\(limit)")
            ]
        }
    }
}

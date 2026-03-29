//
//  CarEndpoint.swift
//  car-journal
//
//  Created by Rayendra Timotius Sabandar on 25/03/26.
//

import Foundation

enum FuelEndpoint: Endpoint {
    case list(name: String, token: String)
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
        case let .list(_, token):
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
        case let .list(name, _):
            return [
                URLQueryItem(name: "name", value: "\(name)")
            ]
        }
    }
}

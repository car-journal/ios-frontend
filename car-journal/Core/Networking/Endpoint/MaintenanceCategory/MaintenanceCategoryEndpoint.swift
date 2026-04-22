//
//  MaintenanceCategoryEndpoint.swift
//  car-journal
//

import Foundation

struct MaintenanceCategoryCreateRequest: Encodable {
    let name: String
    let description: String?
}

struct MaintenanceCategoryUpdateRequest: Encodable {
    let name: String
    let description: String?
}

enum MaintenanceCategoryEndpoint: Endpoint {
    case list(name: String?, sorts: String?, page: Int, limit: Int, token: String)
    case findByID(categoryID: String, token: String)
    case create(payload: MaintenanceCategoryCreateRequest, token: String)
    case update(categoryID: String, payload: MaintenanceCategoryUpdateRequest, token: String)
    case delete(categoryID: String, token: String)
}

extension MaintenanceCategoryEndpoint {
    var path: String {
        switch self {
        case .list, .create:
            return "/v1/internal/maintenance-categories"
        case let .findByID(id, _),
             let .update(id, _, _),
             let .delete(id, _):
            return "/v1/internal/maintenance-categories/\(id)"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .list, .findByID: return .get
        case .create:          return .post
        case .update:          return .patch
        case .delete:          return .delete
        }
    }

    var headers: [String: String]? {
        let token: String
        switch self {
        case let .list(_, _, _, _, t),
             let .findByID(_, t),
             let .create(_, t),
             let .update(_, _, t),
             let .delete(_, t):
            token = t
        }
        return ["Authorization": "Bearer \(token)"]
    }

    var body: (any Encodable)? {
        switch self {
        case let .create(payload, _): return payload
        case let .update(_, payload, _): return payload
        default: return nil
        }
    }

    var queryItems: [URLQueryItem]? {
        switch self {
        case let .list(name, sorts, page, limit, _):
            var items: [URLQueryItem] = [
                URLQueryItem(name: "page", value: "\(page)"),
                URLQueryItem(name: "limit", value: "\(limit)")
            ]
            if let name, !name.isEmpty {
                items.append(URLQueryItem(name: "name", value: name))
            }
            if let sorts, !sorts.isEmpty {
                items.append(URLQueryItem(name: "sorts", value: sorts))
            }
            return items
        default: return nil
        }
    }
}

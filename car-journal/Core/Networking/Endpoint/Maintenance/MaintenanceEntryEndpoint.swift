//
//  MaintenanceEntryEndpoint.swift
//  car-journal
//

import Foundation

enum MaintenanceEntryEndpoint: Endpoint {
    case list(carID: String, name: String?, sorts: String?, page: Int, limit: Int, token: String)
    case create(carID: String, payload: MaintenanceEntryCreateRequest, token: String)
    case update(entryID: String, payload: MaintenanceEntryUpdateRequest, token: String)
    case delete(entryID: String, token: String)
}

extension MaintenanceEntryEndpoint {
    var path: String {
        switch self {
        case let .list(carID, _, _, _, _, _):
            return "/v1/internal/maintenance-entries/\(carID)"
        case let .create(carID, _, _):
            return "/v1/internal/maintenance-entries/\(carID)"
        case let .update(entryID, _, _):
            return "/v1/internal/maintenance-entries/\(entryID)"
        case let .delete(entryID, _):
            return "/v1/internal/maintenance-entries/\(entryID)"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .list:   return .get
        case .create: return .post
        case .update: return .patch
        case .delete: return .delete
        }
    }

    var headers: [String: String]? {
        let token: String
        switch self {
        case let .list(_, _, _, _, _, t),
             let .create(_, _, t),
             let .update(_, _, t),
             let .delete(_, t):
            token = t
        }
        return ["Authorization": "Bearer \(token)"]
    }

    var body: (any Encodable)? {
        switch self {
        case let .create(_, payload, _): return payload
        case let .update(_, payload, _): return payload
        default: return nil
        }
    }

    var queryItems: [URLQueryItem]? {
        switch self {
        case let .list(_, name, sorts, page, limit, _):
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

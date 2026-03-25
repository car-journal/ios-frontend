//
//  PaginationMeta.swift
//  car-journal
//
//  Created by Rayendra Timotius Sabandar on 25/03/26.
//

import Foundation

struct PaginationMeta: Decodable {
    let affectedRecords: Int
    let lastPage: Int
    let count: Int
    let hasNext: Bool
}

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

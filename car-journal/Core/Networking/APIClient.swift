//
//  APIClient.swift
//  car-journal
//
//  Created by Rayendra Timotius Sabandar on 23/03/26.
//

import Foundation

final class APIClient {
    private let baseURL: URL
    private let session: URLSession
    private let decoder: JSONDecoder
    
    init(
        baseURL: URL,
        session: URLSession = .shared,
        decoder: JSONDecoder = .apiDecoder
    ){
        self.baseURL = baseURL
        self.session = session
        self.decoder = decoder
    }
    
    func send<T: Decodable>(_ endpoint: Endpoint) async throws -> T {
        let request = try endpoint.makeRequest(baseURL: baseURL)
        
        let (data, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        if let raw = String(data: data, encoding: .utf8) {
               print("Raw response:", raw)
           } else {
               print("Unable to convert data to string")
           }
        
        guard 200..<300 ~= httpResponse.statusCode else {
            throw NetworkError.serverError(httpResponse.statusCode)
        }
        
        return try decoder.decode(T.self, from: data)
    }
}



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
    private let encoder: JSONEncoder
    
    init(
        baseURL: URL,
        session: URLSession = .shared,
        decoder: JSONDecoder = .apiDecoder,
        encoder: JSONEncoder = .apiEncoder()
    ){
        self.baseURL = baseURL
        self.session = session
        self.decoder = decoder
        self.encoder = encoder
    }
    
    func send<T: Decodable>(_ endpoint: Endpoint) async throws -> T {
        do {
            let request = try endpoint.makeRequest(baseURL: baseURL, encoder: encoder)
            
            let (data, response) = try await session.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw NetworkError.invalidResponse
            }
            
            #if DEBUG
            if let raw = String(data: data, encoding: .utf8) {
                print("Endpoint:", endpoint.path)
                print("Raw response:", raw)
            }
            #endif
            
            guard 200..<300 ~= httpResponse.statusCode else {
                throw NetworkError.serverError(httpResponse.statusCode)
            }
            return try decodeResponse(data, as: T.self)
        } catch {
            #if DEBUG
            print("error send:", error)
            #endif
            throw error
        }
    }
    
    private func decodeResponse<T: Decodable>(_ data: Data, as type: T.Type) throws -> T {
        // TODO: create a screen to handle (show) error
        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            if let apiError = try? decoder.decode(APIErrorResponse.self, from: data) {
                throw apiError.error
            }
            throw error
        }
    }
}



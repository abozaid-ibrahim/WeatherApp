//
//  Bundle+Decoder.swift
//  WeatherApp
//
//  Created by abuzeid on 30.09.20.
//  Copyright © 2020 abuzeid. All rights reserved.
//

import Foundation

public extension Bundle {
    func decode<T: Decodable>(_: T.Type, from file: String) throws -> T {
        guard let url = self.url(forResource: file, withExtension: nil) else {
            throw NetworkError.badRequest
        }

        guard let data = try? Data(contentsOf: url) else {
            throw NetworkError.noData
        }
        do {
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .formatted(DateFormatter.defaultJsonFormatter)
            return try decoder.decode(T.self, from: data)
        } catch {
            log(error, level: .error)
            throw NetworkError.failedToParseData
        }
    }
}


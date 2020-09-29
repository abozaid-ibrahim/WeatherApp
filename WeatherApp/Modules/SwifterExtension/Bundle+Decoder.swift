//
//  Bundle+Decoder.swift
//  WeatherApp
//
//  Created by abuzeid on 30.09.20.
//  Copyright © 2020 abuzeid. All rights reserved.
//

import Foundation

extension Bundle {
    func decode<T: Decodable>(_: T.Type, from file: String) throws -> T {
        guard let url = self.url(forResource: file, withExtension: nil) else {
            throw NetworkError.badRequest
        }

        guard let data = try? Data(contentsOf: url) else {
            throw NetworkError.noData
        }
        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            log(error, level: .error)
            throw NetworkError.failedToParseData
        }
    }
}

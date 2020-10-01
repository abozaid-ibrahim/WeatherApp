//
//  Data+Codable.swift
//  WeatherApp
//
//  Created by abuzeid on 29.09.20.
//  Copyright © 2020 abuzeid. All rights reserved.
//

import Foundation

extension Data {
    func parse<T: Decodable>() -> T? {
        do {
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .formatted(DateFormatter.defaultJsonFormatter)
            return try decoder.decode(T.self, from: self)
        } catch let error {
            log(error)
        }
        return nil
    }
}

extension DateFormatter{
    static var defaultJsonFormatter:DateFormatter{
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter
    }
}

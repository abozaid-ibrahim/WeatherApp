//
//  LocalWeatherLoader.swift
//  WeatherApp
//
//  Created by abuzeid on 30.09.20.
//  Copyright © 2020 abuzeid. All rights reserved.
//

import Foundation

final class LocalWeatherLoader: WeatherDataSource {
    func loadTodayForecast(days: Int, compeletion: @escaping (Result<WeatherResponse, NetworkError>) -> Void) {
        do {
            let response = try Bundle.main.decode(WeatherResponse.self, from: "forecast")
            compeletion(.success(response))
        } catch {
            compeletion(.failure(.noData))
        }
    }
}

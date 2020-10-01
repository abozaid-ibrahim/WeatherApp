//
//  LocalWeatherLoader.swift
//  WeatherApp
//
//  Created by abuzeid on 30.09.20.
//  Copyright © 2020 abuzeid. All rights reserved.
//

import Foundation

final class LocalWeatherLoader: WeatherDataSource {
    var config: LoaderConfig?

    func loadTodayForecast(city: String, days: Int, compeletion: @escaping (Result<WeatherResponse, NetworkError>) -> Void) {
        do {
            let response = try Bundle.main.decode(WeatherResponse.self, from: "forecast.json")
            compeletion(.success(response))
        } catch {
            compeletion(.failure(.noData))
        }
    }
}

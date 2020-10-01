//
//  RemoteWeatherLoader.swift
//  WeatherApp
//
//  Created by abuzeid on 29.09.20.
//  Copyright © 2020 abuzeid. All rights reserved.
//

import Foundation

class RemoteWeatherLoader: WeatherDataSource {
    private(set) var config: LoaderConfig?
    let apiClient: ApiClient

    init(apiClient: ApiClient = HTTPClient(), config: LoaderConfig? = LoaderConfig()) {
        self.apiClient = apiClient
        self.config = config
    }

    func loadTodayForecast(city: String, days: Int, compeletion: @escaping (Result<WeatherResponse, NetworkError>) -> Void) {
        let api = WeatherAPI.weatherToday(city: city, days: days)
        apiClient.getData(of: api) { [weak self] result in
            switch result {
            case let .success(data):
                if let response: WeatherResponse = data.parse() {
                    self?.config?.setLastUpdate()
                    compeletion(.success(response))
                } else {
                    compeletion(.failure(.failedToParseData))
                }
            case let .failure(error):
                compeletion(.failure(error))
            }
        }
    }
}

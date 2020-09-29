//
//  RemoteWeatherLoader.swift
//  WeatherApp
//
//  Created by abuzeid on 29.09.20.
//  Copyright © 2020 abuzeid. All rights reserved.
//

import Foundation
final class RemoteWeatherLoader: WeatherDataSource {
    let apiClient: ApiClient

    init(apiClient: ApiClient = HTTPClient()) {
        self.apiClient = apiClient
    }

    func loadTodayForecast(compeletion: @escaping (Result<WeatherResponse, Error>) -> Void) {
        let api = WeatherAPI.weatherToday(offset: 0)
        apiClient.getData(of: api) { [weak self] result in
            switch result {
            case let .success(data):
                if let response: WeatherResponse = data.parse(){
                          
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

//
//  RemoteWeatherLoader.swift
//  WeatherApp
//
//  Created by abuzeid on 29.09.20.
//  Copyright © 2020 abuzeid. All rights reserved.
//

import Foundation

final class RemoteWeatherLoader: WeatherDataSource {
    var config: LoaderConfig?
    
    let apiClient: ApiClient

    init(apiClient: ApiClient = HTTPClient(),config:LoaderConfig? = nil) {
        self.apiClient = apiClient
        self.config = config
    }

    func loadTodayForecast(city:String,days:Int,compeletion: @escaping (Result<WeatherResponse, NetworkError>) -> Void) {
        let api = WeatherAPI.weatherToday(city: city, days: days)
        apiClient.getData(of: api) { [weak self] result in
            switch result {
            case let .success(data):
                if let response: WeatherResponse = data.parse() {
                    compeletion(.success(response))
                    self?.config?.setLastUpdate()
                } else {
                    compeletion(.failure(.failedToParseData))
                }
            case let .failure(error):
                compeletion(.failure(error))
            }
        }
    }
  
}

enum UserDefaultsKeys: String {
    case apiLastUpdated
}

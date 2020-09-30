//
//  WeatherDataSource.swift
//  WeatherApp
//
//  Created by abuzeid on 29.09.20.
//  Copyright © 2020 abuzeid. All rights reserved.
//

import Foundation

protocol WeatherDataSource {
    var config: LoaderConfig? { get }
    func loadTodayForecast(city: String, days: Int, compeletion: @escaping (Result<WeatherResponse, NetworkError>) -> Void)
}

final class WeatherLoader: WeatherDataSource {
    let localLoader: WeatherDataSource
    let remoteLoader: WeatherDataSource
    let config: LoaderConfig?

    init(localLoader: WeatherDataSource = LocalWeatherLoader(),
         remoteLoader: WeatherDataSource = RemoteWeatherLoader(),
         config: LoaderConfig = LoaderConfig()) {
        self.localLoader = localLoader
        self.remoteLoader = remoteLoader
        self.config = config
    }

    func loadTodayForecast(city: String, days: Int, compeletion: @escaping (Result<WeatherResponse, NetworkError>) -> Void) {
        let loader = (config?.shouldLoadLocally ?? false) ? localLoader : remoteLoader
        loader.loadTodayForecast(city: city, days: days, compeletion: compeletion)
    }
}

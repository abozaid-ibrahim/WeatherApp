//
//  WeatherDataSource.swift
//  WeatherApp
//
//  Created by abuzeid on 29.09.20.
//  Copyright © 2020 abuzeid. All rights reserved.
//

import Foundation
protocol WeatherDataSource {
    func loadTodayForecast(compeletion: @escaping (Result<WeatherResponse, Error>) -> Void)
}

final class WeatherLoader: WeatherDataSource {
    var shouldLoadRemotely: Bool { return true }

    let localLoader: WeatherDataSource
    let remoteLoader: WeatherDataSource
    init(localLoader: WeatherDataSource = RemoteWeatherLoader(),
         remoteLoader: WeatherDataSource = RemoteWeatherLoader()) {
        self.localLoader = localLoader
        self.remoteLoader = remoteLoader
    }

    func loadTodayForecast(compeletion: @escaping (Result<WeatherResponse, Error>) -> Void) {
        let loader = shouldLoadRemotely ? remoteLoader : localLoader
        loader.loadTodayForecast(compeletion: compeletion)
    }
}

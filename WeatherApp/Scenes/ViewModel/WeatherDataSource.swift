//
//  WeatherDataSource.swift
//  WeatherApp
//
//  Created by abuzeid on 29.09.20.
//  Copyright © 2020 abuzeid. All rights reserved.
//

import Foundation

protocol WeatherDataSource {
    func loadTodayForecast(days: Int, compeletion: @escaping (Result<WeatherResponse, NetworkError>) -> Void)
}

final class WeatherLoader: WeatherDataSource {
    let localLoader: WeatherDataSource
    let remoteLoader: WeatherDataSource
    var isOfflineMode = true

    init(localLoader: WeatherDataSource = LocalWeatherLoader(),
         remoteLoader: WeatherDataSource = RemoteWeatherLoader()) {
        self.localLoader = localLoader
        self.remoteLoader = remoteLoader
    }

    private var shouldLoadLocally: Bool {
        let lastCallValid = true
        return isOfflineMode || lastCallValid || (!Reachability.shared.hasInternet())
    }

    func loadTodayForecast(days: Int, compeletion: @escaping (Result<WeatherResponse, NetworkError>) -> Void) {
        let loader = shouldLoadLocally ? remoteLoader : localLoader
        loader.loadTodayForecast(days: days, compeletion: compeletion)
    }
}

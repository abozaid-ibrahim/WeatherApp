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
         config: LoaderConfig) {
        self.localLoader = localLoader
        self.remoteLoader = remoteLoader
        self.config = config
    }

    private var shouldLoadLocally: Bool {
        return config?.isOfflineMode ?? false || lastCallValid || (!Reachability.shared.hasInternet())
    }

    var lastCallValid: Bool {
        guard let updateDate = UserDefaults.standard.object(forKey: UserDefaultsKeys.apiLastUpdated.rawValue) as? Date else {
            return false
        }
        let timeDiff = Date() - updateDate
        return timeDiff.hours < 3
    }

    func loadTodayForecast(city: String, days: Int, compeletion: @escaping (Result<WeatherResponse, NetworkError>) -> Void) {
        let loader = shouldLoadLocally ? remoteLoader : localLoader
        loader.loadTodayForecast(city: city, days: days, compeletion: compeletion)
    }
}

final class LoaderConfig {
    var isOfflineMode = true
}

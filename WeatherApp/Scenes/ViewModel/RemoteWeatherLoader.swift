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

    init(apiClient: ApiClient = HTTPClient()) {
        self.apiClient = apiClient
    }

    func loadTodayForecast(city:String,days:Int,compeletion: @escaping (Result<WeatherResponse, NetworkError>) -> Void) {
        let api = WeatherAPI.weatherToday(city: city, days: days)
        apiClient.getData(of: api) { [weak self] result in
            switch result {
            case let .success(data):
                if let response: WeatherResponse = data.parse() {
                    compeletion(.success(response))
                    self?.cachData(response)
                } else {
                    compeletion(.failure(.failedToParseData))
                }
            case let .failure(error):
                compeletion(.failure(error))
            }
        }
    }
    private func cachData(_ data: WeatherResponse) {
           DispatchQueue.global().async {
               UserDefaults.standard.set(Date(), forKey: UserDefaultsKeys.apiLastUpdated.rawValue)
               UserDefaults.standard.synchronize()
//               CoreDataHelper.shared.save(data: data, entity: .heroes)
           }
       }
}

enum UserDefaultsKeys: String {
    case apiLastUpdated
}

//
//  WeatherViewModel.swift
//  WeatherApp
//
//  Created by abuzeid on 29.09.20.
//  Copyright © 2020 abuzeid. All rights reserved.
//

import Foundation
typealias WeatherResponse = String
protocol WeatherViewModelType {
    // output
    var dataList: [Weather] { get }
}

final class WeatherViewModel: WeatherViewModelType {
    private let forcastLoader: WeatherDataSource
    private(set) var dataList: [Weather] = []

    init(loader: WeatherDataSource = WeatherLoader()) {
        forcastLoader = loader
    }

    func loadData() {
        forcastLoader.loadTodayForecast(compeletion: { [weak self] data in
            guard let self = self else { return }
            switch data {
            case let .success(response):
                print(response)
            case let .failure(error):
                print(error)
            }

        })
    }
}

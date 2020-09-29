//
//  WeatherViewModel.swift
//  WeatherApp
//
//  Created by abuzeid on 29.09.20.
//  Copyright © 2020 abuzeid. All rights reserved.
//

import Foundation

protocol WeatherViewModelType {
    var reloadData: Observable<Bool> { get }
    var dataList: [ForecastList] { get }
    func loadData(offline: Bool)
}

final class WeatherViewModel: WeatherViewModelType {
    private let forcastLoader: WeatherDataSource
    private let days: Int = 5
    let reloadData: Observable<Bool> = .init(false)
    private(set) var dataList: [ForecastList] = []

    init(loader: WeatherDataSource = WeatherLoader()) {
        forcastLoader = loader
    }

    func loadData(offline: Bool) {
        // TODO: remove explicit casting
        guard let loader = forcastLoader as? WeatherLoader else { return }
        loader.isOfflineMode = offline
        forcastLoader.loadTodayForecast(days: days, compeletion: { [weak self] data in
            guard let self = self else { return }
            switch data {
            case let .success(response):
                self.dataList = response.list ?? []
                self.reloadData.next(true)
            case let .failure(error):
                print(error)
            }

        })
    }
}

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
    func loadData()
    // output
    var dataList: [ForecastList] { get }
}

final class WeatherViewModel: WeatherViewModelType {
    var reloadData: Observable<Bool> = .init(false)
    

    private let forcastLoader: WeatherDataSource
    private(set) var dataList: [ForecastList] = []

    init(loader: WeatherDataSource = WeatherLoader()) {
        forcastLoader = loader
    }

    func loadData() {
        forcastLoader.loadTodayForecast(compeletion: { [weak self] data in
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

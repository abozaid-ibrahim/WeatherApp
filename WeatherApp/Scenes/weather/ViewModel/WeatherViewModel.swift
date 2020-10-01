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
    var error: Observable<String?> { get }
    var city: Observable<String?> { get }
    var isLoading: Observable<Bool> { get }
    var dataList: [ForecastList] { get }
    func loadData(offline: Bool)
}

final class WeatherViewModel: WeatherViewModelType {
    private let forcastLoader: WeatherDataSource
    private let days: Int = 5
    let reloadData: Observable<Bool> = .init(false)
    let isLoading: Observable<Bool> = .init(false)
    let error: Observable<String?> = .init(nil)
    let city: Observable<String?> = .init("Munich")
    private(set) var dataList: [ForecastList] = []

    init(loader: WeatherDataSource = WeatherLoader(config: LoaderConfig())) {
        forcastLoader = loader
    }
    
    func loadData(offline: Bool) {
        reset()
        isLoading.next(true)
        forcastLoader.config?.isOfflineMode = offline
        forcastLoader.loadTodayForecast(city: city.value ?? "", days: days, compeletion: { [weak self] data in
            guard let self = self else { return }
            switch data {
            case let .success(response):
                self.dataList =  response.list ?? []
                self.reloadData.next(true)
            case let .failure(error):
                self.error.next(error.localizedDescription)
            }
            self.isLoading.next(false)
            
        })
    }
    
    private func reset() {
        dataList.removeAll()
        reloadData.next(true)
    }
}

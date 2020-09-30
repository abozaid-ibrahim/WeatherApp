//
//  WeatherAppTests.swift
//  WeatherAppTests
//
//  Created by abuzeid on 29.09.20.
//  Copyright © 2020 abuzeid. All rights reserved.
//

@testable import WeatherApp
import XCTest

final class WeatherViewModelTests: XCTestCase {
    func testWeatherLoader_HasConnection_and_DataExpired_and_isOfflineSwitchedOn() throws {
        let config = LoaderConfig(TrueReachability())
        config.setLastUpdate(to: Date().addingTimeInterval(-Double(config.intervalInSeconds + 2)))
        XCTAssertEqual(config.lastCallValid, false)
        config.isOfflineMode = true
        XCTAssertEqual(config.shouldLoadLocally, true)

        let viewModel = WeatherViewModel(loader: WeatherLoader(localLoader: MockedLocalLoaderSuccessCase(),
                                                               remoteLoader: MockedRemoteLoader_Failure(),
                                                               config: config))
        let queue = DispatchQueue(label: "FileLoaderTests")
        queue.sync {
            viewModel.loadData(offline: config.isOfflineMode)
        }
        XCTAssertEqual(viewModel.dataList.count, 5)
    }

    func testWeatherLoader_DataExpired_and_isOfflineSwitchedOff_and_HasNoConnection() throws {
        let config = LoaderConfig(FalseReachability())
        config.isOfflineMode = false
        config.setLastUpdate(to: Date().addingTimeInterval(-Double(config.intervalInSeconds + 2)))
        XCTAssertEqual(config.lastCallValid, false)
        XCTAssertEqual(config.shouldLoadLocally, true)

        let viewModel = WeatherViewModel(loader: WeatherLoader(localLoader: MockedLocalLoaderSuccessCase(),
                                                               remoteLoader: MockedRemoteLoader_Failure(),
                                                               config: config))

        let queue = DispatchQueue(label: "FileLoaderTests")
        queue.sync {
            viewModel.loadData(offline: config.isOfflineMode)
        }
        XCTAssertEqual(viewModel.dataList.count, 5)
    }

    func testWeatherLoader_HasConnection_and_ValidInterval_and_isOfflineSwitchedOn() throws {
        let config = LoaderConfig(TrueReachability())
        config.isOfflineMode = false
        config.setLastUpdate(to: Date().addingTimeInterval(-Double(config.intervalInSeconds - 1)))
        XCTAssertEqual(config.lastCallValid, true)
        XCTAssertEqual(config.shouldLoadLocally, true)
        let viewModel = WeatherViewModel(loader: WeatherLoader(localLoader: MockedLocalLoaderSuccessCase(),
                                                               remoteLoader: MockedRemoteLoader_Failure(),
                                                               config: config))

        let queue = DispatchQueue(label: "FileLoaderTests")
        queue.sync {
            viewModel.loadData(offline: config.isOfflineMode)
        }
        XCTAssertEqual(viewModel.dataList.count, 5)
    }

    func testWeatherLoaderShouldLoadRemotelyOn_ExpiredInterval() throws {
        let config = LoaderConfig(TrueReachability())
        config.isOfflineMode = false
        config.setLastUpdate(to: Date().addingTimeInterval(-Double(config.intervalInSeconds + 2)))
        XCTAssertEqual(config.lastCallValid, false)
        XCTAssertEqual(config.shouldLoadLocally, false)
        let loader = WeatherLoader(localLoader: MockedLocalLoaderSuccessCase(),
                                   remoteLoader: MockedRemoteLoader_Failure(),
                                   config: config)
        let exp = expectation(description: "Wait_Completion")
        loader.loadTodayForecast(city: "Berlin", days: 5, compeletion: { result in
            if case .success = result {
                XCTFail("Should call failure, expect to use remote loader")
            }
            exp.fulfill()
        })
        let viewModel = WeatherViewModel(loader: WeatherLoader(localLoader: MockedLocalLoaderSuccessCase(),
                                                               remoteLoader: MockedRemoteLoader_Failure(),
                                                               config: config))

        let queue = DispatchQueue(label: "FileLoaderTests")
        queue.sync {
            viewModel.loadData(offline: config.isOfflineMode)
        }
        XCTAssertEqual(viewModel.dataList.count, 0)
        wait(for: [exp], timeout: 0.01)
    }
}

final class MockedLocalLoaderSuccessCase: WeatherDataSource {
    var config: LoaderConfig?

    func loadTodayForecast(city: String, days: Int, compeletion: @escaping (Result<WeatherResponse, NetworkError>) -> Void) {
        compeletion(.success(WeatherResponseFactory().response))
    }
}

final class MockedRemoteLoader_Failure: WeatherDataSource {
    var config: LoaderConfig?

    func loadTodayForecast(city: String, days: Int, compeletion: @escaping (Result<WeatherResponse, NetworkError>) -> Void) {
        compeletion(.failure(.noData))
    }
}

final class WeatherResponseFactory {
    var forcastList: [ForecastList] {
        let obj = ForecastList(dt: nil, main: nil, weather: nil, clouds: nil, wind: nil, visibility: nil, pop: nil, sys: nil, dtTxt: nil, rain: nil)
        return .init(repeating: obj, count: 5)
    }

    var response: WeatherResponse {
        return WeatherResponse(cod: nil, message: nil, cnt: nil, list: forcastList, city: nil)
    }
}

final class FalseReachability: ReachabilityType {
    func hasInternet() -> Bool {
        return false
    }
}

final class TrueReachability: ReachabilityType {
    func hasInternet() -> Bool {
        return true
    }
}

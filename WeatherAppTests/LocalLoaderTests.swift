//
//  WeatherAppTests.swift
//  WeatherAppTests
//
//  Created by abuzeid on 29.09.20.
//  Copyright © 2020 abuzeid. All rights reserved.
//

@testable import WeatherApp
import XCTest

final class LocalLoaderTests: XCTestCase {
    private func getViewModel(with config: LoaderConfig) -> WeatherViewModel {
        return WeatherViewModel(loader: WeatherLoader(localLoader: MockedLocalLoaderSuccessCase(),
                                                      remoteLoader: MockedRemoteLoader_Failure(),
                                                      config: config))
    }

    func testWeatherLoader_HasConnection_and_DataExpired_and_isOfflineSwitchedOn() throws {
        let config = LoaderConfig(TrueReachability())
        config.setLastUpdate(to: APIInterval().expired)

        XCTAssertEqual(config.isDataStillValid, false)
        config.isOfflineMode = true
        XCTAssertEqual(config.shouldLoadLocally, true)
        let viewModel = getViewModel(with: config)
        viewModel.loadData(offline: config.isOfflineMode)

        XCTAssertEqual(viewModel.dataList.count, 5)
    }

    func testWeatherLoader_DataExpired_and_isOfflineSwitchedOff_and_HasNoConnection() throws {
        let config = LoaderConfig(FalseReachability())
        config.isOfflineMode = false
        config.setLastUpdate(to: APIInterval().expired)
        XCTAssertEqual(config.isDataStillValid, false)
        XCTAssertEqual(config.shouldLoadLocally, true)

        let viewModel = getViewModel(with: config)
        viewModel.loadData(offline: config.isOfflineMode)

        XCTAssertEqual(viewModel.dataList.count, 5)
    }

    func testWeatherLoader_HasConnection_and_ValidInterval_and_isOfflineSwitchedOn() throws {
        let config = LoaderConfig(TrueReachability())
        config.isOfflineMode = false
        config.setLastUpdate(to: APIInterval().valid)
        XCTAssertEqual(config.isDataStillValid, true)
        XCTAssertEqual(config.shouldLoadLocally, true)
        let viewModel = getViewModel(with: config)

        viewModel.loadData(offline: config.isOfflineMode)
        XCTAssertEqual(viewModel.dataList.count, 5)
    }
}

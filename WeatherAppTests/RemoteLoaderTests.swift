//
//  WeatherRemoteLoadingTests.swift
//  WeatherAppTests
//
//  Created by abuzeid on 01.10.20.
//  Copyright © 2020 abuzeid. All rights reserved.
//

import XCTest
@testable import WeatherApp

final class WeatherRemoteLoadingTests:  XCTestCase {
    private func getViewModel(with config: LoaderConfig,
                              loader:WeatherDataSource = MockedRemoteLoader_Failure()) -> WeatherViewModel {
        return WeatherViewModel(loader:
            WeatherLoader(localLoader: MockedLocalLoaderSuccessCase(),
                          remoteLoader: loader,
                          config: config))
    }
    
    
    func testWeatherLoaderShouldLoadRemotelyOn_ExpiredInterval_APIFails() throws {
        let config = LoaderConfig(TrueReachability())
        config.isOfflineMode = false
        config.setLastUpdate(to: APIInterval().expired)
        XCTAssertEqual(config.isDataStillValid, false)
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
        let viewModel = getViewModel(with: config)
        
        viewModel.loadData(offline: config.isOfflineMode)
        XCTAssertEqual(viewModel.dataList.count, 0)
        wait(for: [exp], timeout: 0.01)
    }
    func testWeatherLoaderShouldLoadRemotelyOn_ExpiredInterval_APISuccess() throws {
        let config = LoaderConfig(TrueReachability())
        config.isOfflineMode = false
        config.setLastUpdate(to: APIInterval().expired)
        XCTAssertEqual(config.isDataStillValid, true)
        XCTAssertEqual(config.shouldLoadLocally, true)
        let viewModel = getViewModel(with: config, loader: MockedRemoteLoader_Success(apiClient:MockedApiClient_Success()))
        
        viewModel.loadData(offline: config.isOfflineMode)
        XCTAssertEqual(viewModel.dataList.count, 2)
    }
    
    func testDateFormmater() throws {
        let obj  = WeatherResponseFactory().forcastList.first
        XCTAssertEqual("Wednesday Sep 30, 2020", obj?.formattedDate)
    }
}

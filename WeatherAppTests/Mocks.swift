//
//  Mocks.swift
//  WeatherAppTests
//
//  Created by abuzeid on 01.10.20.
//  Copyright © 2020 abuzeid. All rights reserved.
//

import Foundation
@testable import WeatherApp
// MARK: - MockedLocalLoader

final class MockedLocalLoaderSuccessCase: WeatherDataSource {
    var config: LoaderConfig?
    
    func loadTodayForecast(city: String, days: Int, compeletion: @escaping (Result<WeatherResponse, NetworkError>) -> Void) {
        compeletion(.success(WeatherResponseFactory().response))
    }
}
// MARK: - MockedRemoteLoader

final class MockedRemoteLoader_Failure: WeatherDataSource {
    var config: LoaderConfig?
    
    func loadTodayForecast(city: String, days: Int, compeletion: @escaping (Result<WeatherResponse, NetworkError>) -> Void) {
        compeletion(.failure(.noData))
    }
}

final class MockedRemoteLoader_Success: RemoteWeatherLoader {
    
    override func loadTodayForecast(city: String, days: Int, compeletion: @escaping (Result<WeatherResponse, NetworkError>) -> Void) {
        compeletion(.success(WeatherResponseFactory().response))
    }
}
// MARK: - APIClient

final class MockedApiClient_Success: ApiClient {
    func getData(of request: RequestBuilder, completion: @escaping (Result<Data, NetworkError>) -> Void) {
        let data = """
{
"list": [
  { "dt_txt": "2020-09-30 00:00:00"},
 { "dt_txt": "2020-09-30 00:00:00"}
]
""".data(using: .utf8)
                completion(.success(data!))
    }
    
    func cancel() {
        
    }
    
   
}
// MARK: - Data Factory

final class WeatherResponseFactory {
    var forcastList: [ForecastList] {
        let date =  DateFormatter.defaultJsonFormatter.date(from: "2020-09-30 00:00:00")!
        let obj = ForecastList(dt: nil, main: nil, weather: nil, visibility: nil, pop: nil, dtTxt: date)
        return .init(repeating: obj, count: 5)
    }
    
    var response: WeatherResponse {
        return WeatherResponse(cod: nil, message: nil, list: forcastList, city: nil)
    }
}
// MARK: - Reachability

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

struct APIInterval {
    
     let expired = Calendar.current.date(byAdding: .minute, value: (LoaderConfig.intervalInMinutes + 1), to: Date())!
     let valid =   Calendar.current.date(byAdding: .minute, value: (LoaderConfig.intervalInMinutes - 1), to: Date())!

}

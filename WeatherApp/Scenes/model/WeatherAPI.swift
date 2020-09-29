//
//  WeatherAPI.swift
//  WeatherApp
//
//  Created by abuzeid on 29.09.20.
//  Copyright © 2020 abuzeid. All rights reserved.
//

import Foundation

enum WeatherAPI {
    case weatherToday(city:String,offset: Int,days:Int)
}

extension WeatherAPI: RequestBuilder {
    var baseURL: URL {
        return URL(string: APIConstants.baseURL)!
    }

    var path: String {
        switch self {
        case .weatherToday:
            return "forecast"
        }
    }

    private var endpoint: URL {
        return URL(string: "\(baseURL)\(path)")!
    }

    var method: HttpMethod {
        return .get
    }
    var parameters: [String: Any] {
        switch self {
        case  .weatherToday(let city, let offset,let days):
            return ["appid": APIConstants.apiKey,
                    "q": city,
                    "cnt":days]
        }
    }

    var request: URLRequest {
        var items = [URLQueryItem]()
        var urlComponents = URLComponents(string: endpoint.absoluteString)
        for (key, value) in parameters {
            items.append(URLQueryItem(name: key, value: "\(value)"))
        }
        urlComponents?.queryItems = items
        var request = URLRequest(url: urlComponents!.url!, cachePolicy: URLRequest.CachePolicy.reloadIgnoringCacheData, timeoutInterval: 30)
        request.httpMethod = method.rawValue
        log(request, level: .info)
        return request
    }
}

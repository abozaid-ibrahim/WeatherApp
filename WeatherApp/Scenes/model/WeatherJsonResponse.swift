//
//  WeatherJsonResponse.swift
//  WeatherApp
//
//  Created by abuzeid on 29.09.20.
//  Copyright © 2020 abuzeid. All rights reserved.
//

import Foundation

struct WeatherResponse: Codable {
    let cod: String?
    let message, cnt: Int?
    let list: [ForecastList]?
    let city: City?
}

struct City: Codable {
    let id: Int?
    let name: String?
    let coord: Coord?
    let country: String?
    let population, timezone, sunrise, sunset: Int?
}

struct Coord: Codable {
    let lat, lon: Double?
}

struct ForecastList: Codable {
    let dt: Int?
    let main: MainClass?
    let weather: [Weather]?
    let visibility: Int?
    let pop: Double?
    let dtTxt: String?

    enum CodingKeys: String, CodingKey {
        case dt, main, weather, clouds, visibility, pop
        case dtTxt = "dt_txt"
    }
}

struct MainClass: Codable {
    let temp, feelsLike, tempMin, tempMax: Double?
    let pressure, seaLevel, grndLevel, humidity: Int?
    let tempKf: Double?

    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case pressure
        case seaLevel = "sea_level"
        case grndLevel = "grnd_level"
        case humidity
        case tempKf = "temp_kf"
    }
}

struct Weather: Codable {
    let id: Int?
    let main: String?
    let weatherDescription, icon: String?

    enum CodingKeys: String, CodingKey {
        case id, main
        case weatherDescription = "description"
        case icon
    }
}

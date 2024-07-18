//
//  weekForecasResponse.swift
//  Weather app
//
//  Created by Rubens Moura Augusto on 07/07/24.
//
// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let forecastWeekResponse = try? JSONDecoder().decode(ForecastWeekResponse.self, from: jsonData)

import Foundation

// MARK: - ForecastWeekResponse
struct WeekForecastResponse: Codable {
    let cod: String
    let message, cnt: Int
    let list: [ListWeekForecast]
    let city: CityWeekForecast
}

// MARK: - CityWeekForecast
struct CityWeekForecast: Codable {
    let id: Int
    let name: String
    let coord: CoordForecastWeek
    let timezone: Int
}

// MARK: - CoordForecastWeek
struct CoordForecastWeek: Codable {
    let lat, lon: Double
}

// MARK: - ListWeekForecast
struct ListWeekForecast: Codable {
    let dt: Int
    let main: MainClass
    let sys: SysWeek
    let dtTxt: String
    let weather: [WeatherWeek]

    enum CodingKeys: String, CodingKey {
        case dt, main, sys
        case dtTxt = "dt_txt"
        case weather = "weather"
    }
}

// MARK: - WeatherWeek
struct WeatherWeek: Codable {
    let id: Int
    let main, description, icon: String
}


// MARK: - MainClass
struct MainClass: Codable {
    let temp, tempMin, tempMax: Double
    let humidity: Int

    enum CodingKeys: String, CodingKey {
        case temp
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case humidity
    }
}

// MARK: - SysWeek
struct SysWeek: Codable {
    let pod: Pod
}

enum Pod: String, Codable {
    case d = "d"
    case n = "n"
}

// MARK: - WindWeekForecast
struct WindWeekForecast: Codable {
    let speed: Double
}

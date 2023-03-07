//
//  WeatherForecastResponse.swift
//  OpenWeatherApp
//
//  Created by Mostafa Elshazly on 07/03/2023.
//

import Foundation

struct WeatherForecastResponse: Decodable {
    let cnt: Int
    let list: [List]
    let city: City?
}

// MARK: - City
struct City: Decodable {
    let id: Int?
    let name: String?
    let coord: Coord?
    let country: String?
    let population, timezone, sunrise, sunset: Double?
}

// MARK: - Coord
struct Coord: Decodable {
    let lat, lon: Double?
}

// MARK: - List
struct List: Decodable {
    let timeOfForecast: Double
    let main: Main
    let weather: [Weather]
    let clouds: Clouds?
    let wind: Wind?
    let visibility: Double?
    let pop: Double?
    let rain: Rain?
    let sys: Sys?
    let dtTxt: Date?

    private enum CodingKeys: String, CodingKey {
        case timeOfForecast = "dt", main, weather, clouds, wind, visibility, pop, rain, sys, dtTxt
    }
}

// MARK: - Clouds
struct Clouds: Decodable {
    let all: Double?
}

// MARK: - Main
struct Main: Decodable {
    let temp, feelsLike, tempMin, tempMax: Double?
    let pressure, seaLevel, grndLevel, humidity: Double?
}

// MARK: - Rain
struct Rain: Decodable {
    let the3H: Double?
}

// MARK: - Sys
struct Sys: Decodable {
    let pod: String?
}

// MARK: - Weather
struct Weather: Decodable {
    let main, weatherDescription, icon: String?
}

// MARK: - Wind
struct Wind: Decodable {
    let speed: Double?
}

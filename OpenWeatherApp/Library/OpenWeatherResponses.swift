//
//  WeatherForecastResponse.swift
//  OpenWeatherApp
//
//  Created by Mostafa Elshazly on 07/03/2023.
//

import Foundation

struct CurrentWeatherResponse: Decodable {
    let weather: [Weather]
    let main: Main
    let timeOfForecast: Double

    private enum CodingKeys: String, CodingKey {
        case timeOfForecast = "dt", main, weather
    }
}

struct WeatherForecastResponse: Decodable {
    let list: [WeatherForecastResponseList]
}

// MARK: - List
struct WeatherForecastResponseList: Decodable {
    let timeOfForecast: Double
    let main: Main
    let weather: [Weather]
    let sys: Sys?

    private enum CodingKeys: String, CodingKey {
        case timeOfForecast = "dt", main, weather, sys
    }
}

// MARK: - Main
struct Main: Decodable {
    let temp, feelsLike: Double?

    private enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
    }

}

// MARK: - Sys
struct Sys: Decodable {
    let pod: String?
}

// MARK: - Weather
struct Weather: Decodable {
    let main, description, icon: String?
}

//
//  OpenWeatherService.swift
//  OpenWeatherApp
//
//  Created by Mostafa Elshazly on 07/03/2023.
//

import Foundation

class OpenWeatherService {

    /// This API key is ideally stored in a plist file that is added to .gitignore so that it won't be
    ///  shared on github. However, for the purposes of this interview, it is included here so that
    ///  it is easier to run without having to do any extra work on the reviewer's side
    private let apiKey = "eb12396ff51e38c197930742348aaa6f"
    private let host = "https://api.openweathermap.org/data/2.5"

    static let shared = OpenWeatherService()

    private init() {}

    enum OpenWeatherError: Error {
        case invalidURL
        case missingData
        case decodingError
        case unknownError
    }

    // MARK: Weather Forecast

    func fetchWeatherForecast(lat: String, lon: String) async throws -> WeatherForecastResponse {
        guard !lat.isEmpty && !lon.isEmpty else { throw OpenWeatherError.missingData }

        let urlString = "\(host)/forecast?lat=\(lat)&lon=\(lon)&appid=\(apiKey)"

        return try await retrieveWeatherForecast(from: urlString)
    }

    func fetchWeatherForecast(city: String) async throws -> WeatherForecastResponse {
        guard !city.isEmpty else { throw OpenWeatherError.missingData }

        let urlString = "\(host)/forecast?q=\(city)&appid=\(apiKey)"

        return try await retrieveWeatherForecast(from: urlString)
    }

    func fetchWeatherForecast(zipCode: String, countryCode: String) async throws -> WeatherForecastResponse {
        guard !zipCode.isEmpty && !countryCode.isEmpty else { throw OpenWeatherError.missingData }

        let urlString = "\(host)/forecast?zip=\(zipCode),\(countryCode)&appid=\(apiKey)"

        return try await retrieveWeatherForecast(from: urlString)
    }

    // MARK: Current Weather

    func fetchCurrentWeather(lat: String, lon: String, units: String) async throws -> CurrentWeatherResponse {
        guard !lat.isEmpty && !lon.isEmpty else { throw OpenWeatherError.missingData }

        let urlString = "\(host)/weather?lat=\(lat)&lon=\(lon)&units=\(units)&appid=\(apiKey)"

        return try await retrieveCurrentWeather(from: urlString)
    }

    func fetchCurrentWeather(city: String, units: String) async throws -> CurrentWeatherResponse {
        guard !city.isEmpty else { throw OpenWeatherError.missingData }

        let urlString = "\(host)/weather?q=\(city)&units=\(units)&appid=\(apiKey)"

        return try await retrieveCurrentWeather(from: urlString)
    }

    func fetchCurrentWeather(zipCode: String,
                             countryCode: String,
                             units: String) async throws -> CurrentWeatherResponse {
        guard !zipCode.isEmpty && !countryCode.isEmpty else { throw OpenWeatherError.missingData }

        let urlString = "\(host)/weather?zip=\(zipCode),\(countryCode)&units=\(units)&appid=\(apiKey)"

        return try await retrieveCurrentWeather(from: urlString)
    }

    // MARK: Decoding

    fileprivate func retrieveWeatherForecast(from urlString: String) async throws -> WeatherForecastResponse {
        guard let url = URL(string: urlString) else {
            throw OpenWeatherError.invalidURL
        }

        let (data, _) = try await URLSession.shared.data(from: url)

        let result = try JSONDecoder().decode(WeatherForecastResponse.self, from: data)
        return result
    }

    fileprivate func retrieveCurrentWeather(from urlString: String) async throws -> CurrentWeatherResponse {
        guard let url = URL(string: urlString) else {
            throw OpenWeatherError.invalidURL
        }

        let (data, _) = try await URLSession.shared.data(from: url)

        let result = try JSONDecoder().decode(CurrentWeatherResponse.self, from: data)
        return result
    }
}

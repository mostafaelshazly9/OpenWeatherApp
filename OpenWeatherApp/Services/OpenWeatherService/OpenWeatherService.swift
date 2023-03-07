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
    static let apiKey = "eb12396ff51e38c197930742348aaa6f"

    enum OpenWeatherError: Error {
        case invalidURL
        case missingData
    }

    static func fetchWeatherForecast(lat: String, lon: String) async throws -> WeatherForecastResponse {
        guard !lat.isEmpty && !lon.isEmpty else { throw OpenWeatherError.missingData }

        let urlString = "https://api.openweathermap.org/data/2.5/forecast?lat=\(lat)&lon=\(lon)&appid=\(apiKey)"
        guard let url = URL(string: urlString) else {
            throw OpenWeatherError.invalidURL
        }

        // Use the async variant of URLSession to fetch data
        // Code might suspend here
        let (data, response) = try await URLSession.shared.data(from: url)
        print("Response:", response)
        print(String(decoding: data, as: UTF8.self))

        // Parse the JSON data
        let result = try JSONDecoder().decode(WeatherForecastResponse.self, from: data)
        print(result)
        return result
    }
}

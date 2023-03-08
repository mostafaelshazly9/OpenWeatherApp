//
//  CurrentWeatherRepository.swift
//  OpenWeatherApp
//
//  Created by Mostafa Elshazly on 08/03/2023.
//

import Foundation

class CurrentWeatherRepository {

    func getCurrentWeather(by query: String) async throws -> CurrentWeather {
        if let currentWeather = CurrentWeatherData.getCurrentWeatherData(for: query) {
            return currentWeather.createCurrentWeather()
        }

        do {
            let weather = try await withCheckedThrowingContinuation { continuation in
                Task {
                    if query.isValidLatLong() {
                        continuation.resume(returning: try await runWeatherFunctionByLatLon(query: query))
                    } else if query.isValidZipCountryCodes() {
                        continuation.resume(returning: try await runWeatherFunctionByZipCountryCodes(query: query))
                    } else {
                        continuation.resume(returning: try await runWeatherFunctionByCity(query: query))
                    }
                }
            }
            return weather
        } catch let error {
            print(error)
            throw error
        }
    }

    func runWeatherFunctionByLatLon(query: String) async throws -> CurrentWeather {
        try await withCheckedThrowingContinuation { continuation in
            Task {
                let query = query.getLatLongFromQuery()
                do {
                    let response = try await OpenWeatherService.shared.fetchCurrentWeather(
                        lat: query.lat, lon: query.lon, units: UserDefaultsService.shared.retrieveUnit())
                    if let weather = [CurrentWeather(from: response)].first {
                        continuation.resume(returning: weather)
                    }
                    continuation.resume(throwing: OpenWeatherService.OpenWeatherError.unknownError)
                } catch let error {
                    print(error)
                    continuation.resume(throwing: OpenWeatherService.OpenWeatherError.decodingError)
                }
            }
        }
    }

    func runWeatherFunctionByZipCountryCodes(query: String) async throws -> CurrentWeather {
        try await withCheckedThrowingContinuation { continuation in
            Task {
                let query = query.getZipCountryCodesFromQuery()
                do {
                    let response = try await OpenWeatherService.shared.fetchCurrentWeather(
                        zipCode: query.zip, countryCode: query.country, units: UserDefaultsService.shared.retrieveUnit())
                    if let weather = [CurrentWeather(from: response)].first {
                        continuation.resume(returning: weather)
                    }
                    continuation.resume(throwing: OpenWeatherService.OpenWeatherError.unknownError)
                } catch let error {
                    print(error)
                    continuation.resume(throwing: OpenWeatherService.OpenWeatherError.decodingError)
                }
            }
        }
    }

    func runWeatherFunctionByCity(query: String) async throws -> CurrentWeather {
        try await withCheckedThrowingContinuation { continuation in
            Task {
                let city = query.replacingOccurrences(of: ", ", with: "")
                do {
                    let response = try await OpenWeatherService.shared.fetchCurrentWeather(city: city, units: UserDefaultsService.shared.retrieveUnit())
                    if let weather = [CurrentWeather(from: response)].first {
                        continuation.resume(returning: weather)
                    }
                    continuation.resume(throwing: OpenWeatherService.OpenWeatherError.unknownError)
                } catch let error {
                    print(error)
                    continuation.resume(throwing: OpenWeatherService.OpenWeatherError.decodingError)
                }
            }
        }
    }
}

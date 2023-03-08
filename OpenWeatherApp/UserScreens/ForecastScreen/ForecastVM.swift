//
//  ForecastVM.swift
//  OpenWeatherApp
//
//  Created by Mostafa Elshazly on 07/03/2023.
//

import Foundation

class ForecastVM: ObservableObject {

    @Published var query = ""
    @Published var forecasts: [Forecast] = []

    func didTapSearchButton() {
        if isValidLatLong() {
            fetchWeatherForecastByLatLon()
        } else if isValidZipCountryCodes() {
            fetchWeatherForecastByZipCountryCodes()
        } else {
            fetchWeatherForecastByCity()
        }
    }

    @MainActor
    private func setForecastsFrom(_ response: WeatherForecastResponse) {
        forecasts = response.list.compactMap { Forecast(from: $0) }
    }

    // MARK: Latitude and Longitude

    private func isValidLatLong() -> Bool {
        if let lat = query.replacingOccurrences(of: " ", with: "").components(separatedBy: ",").first,
           let lon = query.replacingOccurrences(of: " ", with: "").components(separatedBy: ",").last,
           (Double(lat) != nil) && (Double(lon) != nil) {
            return true
        } else {
            return false
        }
    }

    private func getLatLongFromQuery() -> (lat: String, lon: String) {
        if let lat = query.replacingOccurrences(of: " ", with: "").components(separatedBy: ",").first,
           let lon = query.replacingOccurrences(of: " ", with: "").components(separatedBy: ",").last {
            return (lat, lon)
        }
        return ("", "")
    }

    private func fetchWeatherForecastByLatLon() {
        Task {
            let query = getLatLongFromQuery()
            do {
                let response = try await OpenWeatherService.shared.fetchWeatherForecast(lat: query.lat, lon: query.lon)
                await setForecastsFrom(response)
            } catch let error {
                print(error)
            }
        }
    }

    // MARK: Zip code

    private func isValidZipCountryCodes() -> Bool {
        if let zipCode = query.replacingOccurrences(of: " ", with: "").components(separatedBy: ",").first,
           query.replacingOccurrences(of: " ", with: "").components(separatedBy: ",").last != nil,
           let intZipCode = Int(zipCode),
           intZipCode > 0 {
            return true
        } else {
            return false
        }
    }

    private func getZipCountryCodesFromQuery() -> (zip: String, country: String) {
        if let zipCode = query.replacingOccurrences(of: " ", with: "").components(separatedBy: ",").first,
           let countryCode = query.replacingOccurrences(of: " ", with: "").components(separatedBy: ",").last {
            return (zipCode, countryCode.lowercased())
        }
        return ("", "")
    }

    private func fetchWeatherForecastByZipCountryCodes() {
        Task {
            let query = getZipCountryCodesFromQuery()
            do {
                let response = try await OpenWeatherService.shared.fetchWeatherForecast(zipCode: query.zip,
                                                                                 countryCode: query.country)
                await setForecastsFrom(response)
            } catch let error {
                print(error)
            }
        }
    }

    // MARK: City

    private func fetchWeatherForecastByCity() {
        Task {
            let city = query.replacingOccurrences(of: ", ", with: "")
            do {
                let response = try await OpenWeatherService.shared.fetchWeatherForecast(city: city)
                await setForecastsFrom(response)
            } catch let error {
                print(error)
            }
        }
    }
}

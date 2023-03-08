//
//  ForecastVM.swift
//  OpenWeatherApp
//
//  Created by Mostafa Elshazly on 07/03/2023.
//

import Foundation
import CoreLocation

class ForecastVM: ObservableObject {

    @Published var query = ""
    @Published var forecasts: [Forecast] = []
    @Published var previousQueries: [String] = []
    @Published var isShowingOldRQueries = false

    private var queryTask: Task<(), Never>?
    private let manager = CLLocationManager()
    private var delegate: CoreLocationDelegate?

    init(query: String = "", delegate: CoreLocationDelegate? = nil) {
        self.query = query
        self.delegate = delegate
    }

    func didTapSearchButton() {
        cancelQueryTask()
        isShowingOldRQueries = false
        searchForQuery()
    }

    func didTapOldQueriesButton() {
        cancelQueryTask()
        previousQueries = UserDefaultsService.shared.retrieveLast5ForecastQueries().reversed()
        isShowingOldRQueries = true
    }

    func didSelectQuery(_ query: String) {
        self.query = query
        isShowingOldRQueries = false
        searchForQuery()
    }

    func didTapMapPinIcon() {
        Task {
            do {
                let location: CLLocation = try await
                withCheckedThrowingContinuation { [weak self] continuation in
                    self?.delegate = CoreLocationDelegate(manager: manager, continuation: continuation)
                }
                await setQuery(to: "\(location.coordinate.latitude),\(location.coordinate.longitude)")
            } catch let error {
                print(error)
            }
        }
    }

    @MainActor
    private func setQuery(to newQuery: String) {
        query = newQuery
    }

    @MainActor
    private func setForecastsFrom(_ response: WeatherForecastResponse) {
        forecasts = response.list.compactMap { Forecast(from: $0) }
    }

    @MainActor
    private func resetForecasts() {
        forecasts = []
    }

    fileprivate func searchForQuery() {
        Task {
            await resetForecasts()
        }

        if isValidLatLong() {
            fetchWeatherForecastByLatLon()
        } else if isValidZipCountryCodes() {
            fetchWeatherForecastByZipCountryCodes()
        } else {
            fetchWeatherForecastByCity()
        }
    }

    fileprivate func cancelQueryTask() {
        queryTask?.cancel()
        queryTask = nil
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
        queryTask = Task {
            let query = getLatLongFromQuery()
            do {
                let response = try await OpenWeatherService.shared.fetchWeatherForecast(lat: query.lat, lon: query.lon)
                await setForecastsFrom(response)
                UserDefaultsService.shared.saveForecastQuery(self.query)
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
        queryTask = Task {
            let query = getZipCountryCodesFromQuery()
            do {
                let response = try await OpenWeatherService.shared.fetchWeatherForecast(zipCode: query.zip,
                                                                                 countryCode: query.country)
                await setForecastsFrom(response)
                UserDefaultsService.shared.saveForecastQuery(self.query)
            } catch let error {
                print(error)
            }
        }
    }

    // MARK: City

    private func fetchWeatherForecastByCity() {
        queryTask = Task {
            let city = query.replacingOccurrences(of: ", ", with: "")
            do {
                let response = try await OpenWeatherService.shared.fetchWeatherForecast(city: city)
                await setForecastsFrom(response)
                UserDefaultsService.shared.saveForecastQuery(self.query)
            } catch let error {
                print(error)
            }
        }
    }
}

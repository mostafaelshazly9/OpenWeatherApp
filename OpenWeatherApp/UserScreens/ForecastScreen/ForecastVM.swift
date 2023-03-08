//
//  ForecastVM.swift
//  OpenWeatherApp
//
//  Created by Mostafa Elshazly on 07/03/2023.
//

import Foundation

class ForecastVM: BaseWeatherSearchVM {

    override func loadPreviousQueries() -> [String] {
        UserDefaultsService.shared.retrieveLastNQueries(5).reversed()
    }

    @MainActor
    func didTapFilter24h() {
        applyFilterFunction { forecast in
            guard let hour = (Date(timeIntervalSince1970: forecast.date) - Date()).hour else { return false }
            return ( hour < 24)
        }
    }

    @MainActor
    func didTapFilter48h() {
        applyFilterFunction { forecast in
            guard let hour = (Date(timeIntervalSince1970: forecast.date) - Date()).hour else { return false }
            return ( hour < 48)
        }
    }

    override func runWeatherFunctionByLatLon() {
        queryTask = Task {
            let query = query.getLatLongFromQuery()
            do {
                let response = try await OpenWeatherService.shared.fetchWeatherForecast(lat: query.lat, lon: query.lon)
                await setForecastsFrom(response)
                UserDefaultsService.shared.saveQuery(self.query)
            } catch let error {
                print(error)
            }
        }
    }

    override func runWeatherFunctionByZipCountryCodes() {
        queryTask = Task {
            let query = query.getZipCountryCodesFromQuery()
            do {
                let response = try await OpenWeatherService.shared.fetchWeatherForecast(zipCode: query.zip,
                                                                                 countryCode: query.country)
                await setForecastsFrom(response)
                UserDefaultsService.shared.saveQuery(self.query)
            } catch let error {
                print(error)
            }
        }
    }

    override func runWeatherFunctionByCity() {
        queryTask = Task {
            let city = query.replacingOccurrences(of: ", ", with: "")
            do {
                let response = try await OpenWeatherService.shared.fetchWeatherForecast(city: city)
                await setForecastsFrom(response)
                UserDefaultsService.shared.saveQuery(self.query)
            } catch let error {
                print(error)
            }
        }
    }

}

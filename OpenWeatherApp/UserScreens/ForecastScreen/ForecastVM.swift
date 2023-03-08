//
//  ForecastVM.swift
//  OpenWeatherApp
//
//  Created by Mostafa Elshazly on 07/03/2023.
//

import Foundation

class ForecastVM: BaseWeatherSearchVM {

    func viewDidAppear() {
        if let lastQuery = loadPreviousQueries().first {
            Task {
                await setQuery(to: lastQuery)
                searchForQuery()
            }
        }
    }

    override func loadPreviousQueries() -> [String] {
        UserDefaultsService.shared.retrieveLast5ForecastQueries().reversed()
    }

    override func searchForQuery() {
        Task {
            await resetForecasts()

            if isValidLatLong() {
                runWeatherFunctionByLatLon()
            } else if isValidZipCountryCodes() {
                runWeatherFunctionByZipCountryCodes()
            } else {
                runWeatherFunctionByCity()
            }
        }
    }

    override func runWeatherFunctionByLatLon() {
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

    override func runWeatherFunctionByZipCountryCodes() {
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

    override func runWeatherFunctionByCity() {
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

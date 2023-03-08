//
//  CurrentWeatherVM.swift
//  OpenWeatherApp
//
//  Created by Mostafa Elshazly on 08/03/2023.
//

import Foundation

class CurrentWeatherVM: BaseWeatherSearchVM {

    override func loadPreviousQueries() -> [String] {
        UserDefaultsService.shared.retrieveLastNQueries(10).reversed()
    }

    override func runWeatherFunctionByLatLon() {
        queryTask = Task {
            let query = getLatLongFromQuery()
            do {
                let response = try await OpenWeatherService.shared.fetchCurrentWeather(lat: query.lat, lon: query.lon)
                await setForecastsFrom(response)
                UserDefaultsService.shared.saveQuery(self.query)
            } catch let error {
                print(error)
            }
        }
    }

    override func runWeatherFunctionByZipCountryCodes() {
        queryTask = Task {
            let query = getZipCountryCodesFromQuery()
            do {
                let response = try await OpenWeatherService.shared.fetchCurrentWeather(zipCode: query.zip,
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
                let response = try await OpenWeatherService.shared.fetchCurrentWeather(city: city)
                await setForecastsFrom(response)
                UserDefaultsService.shared.saveQuery(self.query)
            } catch let error {
                print(error)
            }
        }
    }
}

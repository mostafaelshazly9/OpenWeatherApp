//
//  CurrentWeatherVM.swift
//  OpenWeatherApp
//
//  Created by Mostafa Elshazly on 08/03/2023.
//

import Foundation
import CoreData

class CurrentWeatherVM: BaseWeatherSearchVM {

    private var units = "metric"
    var displayUnits = "°C"

    init() {
        super.init()
        units = UserDefaultsService.shared.retrieveUnit()
        if units == "imperial" {
            displayUnits = "°F"
        } else {
            displayUnits = "°C"
        }
    }

    func didTapFahrenheit() {
        units = "imperial"
        displayUnits = "°F"
        UserDefaultsService.shared.saveUnit(units)
    }

    func didTapCelsius() {
        units = "metric"
        displayUnits = "°C"
        UserDefaultsService.shared.saveUnit(units)
    }

    override func loadPreviousQueries() -> [String] {
        UserDefaultsService.shared.retrieveLastNQueries(10).reversed()
    }

    override func runWeatherFunctionByLatLon() {
        queryTask = Task {
            let query = query.getLatLongFromQuery()
            do {
                let response = try await OpenWeatherService.shared.fetchCurrentWeather(
                    lat: query.lat, lon: query.lon, units: units)
                await setForecastsFrom(response)
                UserDefaultsService.shared.saveQuery(self.query)
                addCurrentWeather()
            } catch let error {
                print(error)
            }
        }
    }

    override func runWeatherFunctionByZipCountryCodes() {
        queryTask = Task {
            let query = query.getZipCountryCodesFromQuery()
            do {
                let response = try await OpenWeatherService.shared.fetchCurrentWeather(
                    zipCode: query.zip, countryCode: query.country, units: units)
                await setForecastsFrom(response)
                UserDefaultsService.shared.saveQuery(self.query)
                addCurrentWeather()
            } catch let error {
                print(error)
            }
        }
    }

    override func runWeatherFunctionByCity() {
        queryTask = Task {
            let city = query.replacingOccurrences(of: ", ", with: "")
            do {
                let response = try await OpenWeatherService.shared.fetchCurrentWeather(city: city, units: units)
                await setForecastsFrom(response)
                UserDefaultsService.shared.saveQuery(self.query)
                addCurrentWeather()
            } catch let error {
                print(error)
            }
        }
    }

    private func addCurrentWeather() {
        if let weather = results.first as? CurrentWeather {
            CurrentWeatherData.saveNew(query: query, currentWeather: weather)
        }
    }

}

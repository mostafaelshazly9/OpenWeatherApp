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

    func didTapFahrenheit() {
        units = "imperial"
        displayUnits = "°F"
    }

    func didTapCelsius() {
        units = "metric"
        displayUnits = "°C"
    }

    override func loadPreviousQueries() -> [String] {
        UserDefaultsService.shared.retrieveLastNQueries(10).reversed()
    }

    override func runWeatherFunctionByLatLon() {
        queryTask = Task {
            let query = getLatLongFromQuery()
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
            let query = getZipCountryCodesFromQuery()
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
            weather.createCurrentWeatherDataObject()
        }
    }

}

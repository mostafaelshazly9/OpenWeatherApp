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
        Task {
            try await setForecastsFrom(weather: CurrentWeatherRepository.shared.getCurrentWeather(by: query))
            UserDefaultsService.shared.saveQuery(self.query)
            addCurrentWeather()
        }
    }

    override func runWeatherFunctionByZipCountryCodes() {
        runWeatherFunctionByLatLon()
    }

    override func runWeatherFunctionByCity() {
        runWeatherFunctionByLatLon()
    }

    private func addCurrentWeather() {
        if let weather = results.first as? CurrentWeather {
            CurrentWeatherData.saveNew(query: query, currentWeather: weather)
        }
    }

}

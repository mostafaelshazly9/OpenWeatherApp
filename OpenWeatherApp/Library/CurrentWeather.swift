//
//  CurrentWeather.swift
//  OpenWeatherApp
//
//  Created by Mostafa Elshazly on 08/03/2023.
//

import Foundation

struct CurrentWeather: WeatherPresentableProtocol, Identifiable {

    var id: Double { date }

    var date: Double
    var isNight = true
    var title: String
    var description: String
    var icon: String
    var temp: Double?
    var feelsLike: Double?

    init(date: Double, isNight: Bool = false, title: String, description: String, icon: String) {
        self.date = date
        self.isNight = isNight
        self.title = title
        self.description = description
        self.icon = icon
    }

    init(from response: CurrentWeatherResponse) {
        self.date = response.timeOfForecast
        self.isNight = false
        self.title = response.weather.first?.main ?? ""
        self.description = response.weather.first?.description ?? ""
        self.icon = response.weather.first?.icon ?? ""
        self.temp = response.main.temp
        self.feelsLike = response.main.feelsLike
    }

    @discardableResult
    func createCurrentWeatherDataObject() -> CurrentWeatherData {
        let object = CurrentWeatherData(context: PersistenceController.shared.container.viewContext)
        object.date = date
        object.dateStored = Date()
        object.feelsLike = feelsLike ?? 0
        object.temp = temp ?? 0
        object.icon = icon
        object.isNight = isNight
        object.title = title
        object.weatherDescription = description
        try? PersistenceController.shared.container.viewContext.save()
        return object
    }
}

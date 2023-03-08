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
        self.description = response.weather.first?.weatherDescription ?? ""
        self.icon = response.weather.first?.icon ?? ""
    }
}

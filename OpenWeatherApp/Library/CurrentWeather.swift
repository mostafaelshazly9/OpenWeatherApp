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
    var weatherDescription: String
    var icon: String
    var temp: Double?
    var feelsLike: Double?

    init(date: Double, isNight: Bool = false, title: String, description: String, icon: String, temp: Double?, feelsLike: Double?) {
        self.date = date
        self.isNight = isNight
        self.title = title
        self.weatherDescription = description
        self.icon = icon
        self.temp = temp
        self.feelsLike = feelsLike
    }

    init(from response: CurrentWeatherResponse) {
        self.date = response.timeOfForecast
        self.isNight = false
        self.title = response.weather.first?.main ?? ""
        self.weatherDescription = response.weather.first?.weatherDescription ?? ""
        self.icon = response.weather.first?.icon ?? ""
        self.temp = response.main.temp
        self.feelsLike = response.main.feelsLike
    }
}

//
//  CurrentWeatherBanner.swift
//  OpenWeatherApp
//
//  Created by Mostafa Elshazly on 08/03/2023.
//

import SwiftUI

struct CurrentWeatherBanner: View {

    var currentWeather: CurrentWeather

    var body: some View {
        VStack {
            HStack {
                Text(currentWeather.title)
                AsyncImage(url: URL(string: "https://openweathermap.org/img/w/\(currentWeather.icon).png"))
                    .frame(width: 50, height: 50)
            }
            Spacer()
            Text(currentWeather.description)
            Spacer()
            HStack {
                Text("Temperature:")
                Text(String(currentWeather.temp ?? 0))
            }
            Spacer()
            HStack {
                Text("Feels like:")
                Text(String(currentWeather.feelsLike ?? 0))
            }
        }
        .frame(height: 200)
        .multilineTextAlignment(.center)
        .padding(30)
    }
}

struct CurrentWeatherBanner_Previews: PreviewProvider {
    static var previews: some View {
        CurrentWeatherBanner(currentWeather: CurrentWeather(date: 1647766800,
                                                            isNight: true,
                                                            title: "Clouds",
                                                            description: "scattered clouds",
                                                            icon: "03d"))
    }
}

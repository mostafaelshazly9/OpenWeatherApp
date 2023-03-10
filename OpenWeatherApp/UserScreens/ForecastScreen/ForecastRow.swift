//
//  ForecastRow.swift
//  OpenWeatherApp
//
//  Created by Mostafa Elshazly on 08/03/2023.
//

import SwiftUI

struct ForecastRow: View {

    var forecast: Forecast

    var body: some View {
        ZStack {
            if forecast.isNight {
                Color(R.string.localizable.forecastRowBackgroundNight())
            } else {
                Color(R.string.localizable.forecastRowBackgroundDay())
            }
            HStack {
                VStack {
                    Text(forecast.title)
                    Spacer()
                    Text(forecast.weatherDescription)
                }
                Spacer()
                VStack {
                    Text(Date(timeIntervalSince1970: forecast.date).localFromUTC() ?? "")
                    Spacer()
                    AsyncImage(url: URL(string: "https://openweathermap.org/img/w/\(forecast.icon).png"))
                        .frame(width: 50, height: 50)
                }
            }
            .multilineTextAlignment(.center)
        .padding()
        }
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(lineWidth: 1.5)
        )
    }
}

struct ForecastRow_Previews: PreviewProvider {
    static var previews: some View {
        ForecastRow(forecast: Forecast(date: 1647766800,
                                       isNight: true,
                                       title: "Clouds",
                                       description: "scattered clouds",
                                       icon: "03d"))
    }
}

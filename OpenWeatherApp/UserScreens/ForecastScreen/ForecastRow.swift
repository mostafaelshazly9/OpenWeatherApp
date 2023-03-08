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
                    Text(forecast.description)
                }
                Spacer()
                VStack {
                    Text(Date(timeIntervalSince1970: forecast.date).localFromUTC() ?? "")
                    Spacer()
                    AsyncImage(url: URL(string: "https://openweathermap.org/img/w/\(forecast.icon).png"))
                }
            }
            .multilineTextAlignment(.center)
        .padding()
        }
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

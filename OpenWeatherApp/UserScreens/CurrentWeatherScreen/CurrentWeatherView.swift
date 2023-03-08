//
//  CurrentWeatherView.swift
//  OpenWeatherApp
//
//  Created by Mostafa Elshazly on 08/03/2023.
//

import SwiftUI

struct CurrentWeatherView: View {

    @StateObject var viewModel = CurrentWeatherVM()

    var body: some View {
        BaseWeatherSearchView<CurrentWeatherVM, AnyView>(viewModel: viewModel, upper: {
            AnyView(upperView)
        })
    }
}

struct CurrentWeatherView_Previews: PreviewProvider {
    static var previews: some View {
        CurrentWeatherView()
    }
}

// MARK: UI Components

extension CurrentWeatherView {

    var upperView: some View {
        VStack {
            if !viewModel.results.isEmpty,
               let currentWeather = viewModel.results
                .compactMap({ $0 as? CurrentWeather }).first {
                CurrentWeatherBanner(currentWeather: currentWeather, unit: viewModel.displayUnits)
            }
            unitsButtons
        }
    }

    var unitsButtons: some View {
        HStack {
            Button {
                viewModel.didTapCelsius()
            } label: {
                Text("Celsius")
            }
            .modifier(WeatherSearchButtonStyle())

            Button {
                viewModel.didTapFahrenheit()
            } label: {
                Text("Fahrenheit")
            }
            .modifier(WeatherSearchButtonStyle())
        }
    }
}

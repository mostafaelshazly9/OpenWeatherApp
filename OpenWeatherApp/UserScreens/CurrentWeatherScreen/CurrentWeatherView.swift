//
//  CurrentWeatherView.swift
//  OpenWeatherApp
//
//  Created by Mostafa Elshazly on 08/03/2023.
//

import SwiftUI

struct CurrentWeatherView: View {

    @Binding var path: [Int]
    @StateObject var viewModel = CurrentWeatherVM()

    var body: some View {
        BaseWeatherSearchView<CurrentWeatherVM, AnyView>(viewModel: viewModel, upper: {
            AnyView(upperView)
        })
    }
}

struct CurrentWeatherView_Previews: PreviewProvider {
    @State static var path = [Int]()
    static var previews: some View {
        CurrentWeatherView(path: $path)
    }
}

// MARK: UI Components

extension CurrentWeatherView {

    var upperView: some View {
        VStack {
            if !viewModel.results.isEmpty,
               let currentWeather = viewModel.results
                .compactMap({ $0 as? CurrentWeather }).first {
                ZStack {
                    CurrentWeatherBanner(currentWeather: currentWeather, unit: viewModel.displayUnits)
                    VStack {
                        Spacer()
                        HStack {
                            Spacer()
                            NavigationLink("Forecast", value: 2)
                                .modifier(WeatherSearchButtonStyle())
                        }
                    }
                }
            }
            unitsButtons
        }
        .navigationTitle("Current Weather")
        .navigationDestination(for: Int.self) { _ in
            ForecastView(path: $path)
        }
    }

    var unitsButtons: some View {
        VStack {
            Button("Go to Dashboard") {
                path.removeLast(path.count)
            }
            .modifier(WeatherSearchButtonStyle())
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
}

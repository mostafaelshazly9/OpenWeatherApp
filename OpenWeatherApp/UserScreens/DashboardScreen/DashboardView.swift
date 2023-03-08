//
//  DashboardView.swift
//  OpenWeatherApp
//
//  Created by Mostafa Elshazly on 08/03/2023.
//

import SwiftUI

struct DashboardView: View {

    @StateObject var viewModel = CurrentWeatherVM()
    @State private var shouldNavigateToForecastScreen: Bool = false
    @State private var shouldNavigateToCurrentWeatherScreen: Bool = false

    var body: some View {
        NavigationStack {
            VStack {
                if !viewModel.results.isEmpty,
                   let currentWeather = viewModel.results
                    .compactMap({ $0 as? CurrentWeather }).first {
                    CurrentWeatherBanner(currentWeather: currentWeather, unit: viewModel.displayUnits)
                }
                Button {
                    shouldNavigateToForecastScreen = true
                } label: {
                    Text("Go to Weather Forecast")
                }
                .modifier(WeatherSearchButtonStyle())

                Button {
                    shouldNavigateToCurrentWeatherScreen = true
                } label: {
                    Text("Go to Current Weather")
                }
                .modifier(WeatherSearchButtonStyle())
            }
            .navigationTitle("Dashboard")
            .navigationDestination(isPresented: $shouldNavigateToForecastScreen) {
                ForecastView()
            }
            .navigationDestination(isPresented: $shouldNavigateToCurrentWeatherScreen) {
                CurrentWeatherView()
           }
        }
        .onAppear {
            viewModel.viewDidAppear()
        }
    }
}

struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView()
    }
}

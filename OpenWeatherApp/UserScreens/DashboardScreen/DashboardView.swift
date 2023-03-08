//
//  DashboardView.swift
//  OpenWeatherApp
//
//  Created by Mostafa Elshazly on 08/03/2023.
//

import SwiftUI

struct DashboardView: View {

    @StateObject var viewModel = CurrentWeatherVM()

    @State private var path = [Int]()

    var body: some View {
        NavigationStack(path: $path) {
            VStack {
                if !viewModel.results.isEmpty,
                   let currentWeather = viewModel.results
                    .compactMap({ $0 as? CurrentWeather }).first {
                    CurrentWeatherBanner(currentWeather: currentWeather, unit: viewModel.displayUnits)
                }

                NavigationLink("Go to Weather Forecast", value: 2)
                .modifier(WeatherSearchButtonStyle())

                NavigationLink("Go to Current Weather", value: 3)
                .modifier(WeatherSearchButtonStyle())
            }
            .navigationTitle("Dashboard")
            .navigationDestination(for: Int.self) { int in
                if int == 2 {
                    ForecastView(path: $path)
                } else if int == 3 {
                    CurrentWeatherView()
                }
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

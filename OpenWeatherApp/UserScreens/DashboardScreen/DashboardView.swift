//
//  DashboardView.swift
//  OpenWeatherApp
//
//  Created by Mostafa Elshazly on 08/03/2023.
//

import SwiftUI

struct DashboardView: View {

    @StateObject var viewModel = CurrentWeatherVM()

    var body: some View {
        VStack {
            if !viewModel.results.isEmpty,
               let currentWeather = viewModel.results
                .compactMap({ $0 as? CurrentWeather }).first {
                CurrentWeatherBanner(currentWeather: currentWeather, unit: viewModel.displayUnits)
            }
            // TODO: Add navigations
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

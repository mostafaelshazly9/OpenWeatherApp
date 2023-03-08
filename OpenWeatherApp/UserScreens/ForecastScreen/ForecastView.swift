//
//  ForecastView.swift
//  OpenWeatherApp
//
//  Created by Mostafa Elshazly on 07/03/2023.
//

import SwiftUI

struct ForecastView: View {

    @StateObject var viewModel = ForecastVM()

    var body: some View {
        BaseWeatherSearchView<ForecastVM, AnyView>(viewModel: viewModel, lower: { AnyView(forecasts) })
            .onAppear {
                viewModel.viewDidAppear()
            }
    }
}

struct ForecastView_Previews: PreviewProvider {
    static var previews: some View {
        ForecastView()
    }
}

// MARK: UI components
extension ForecastView {

    var forecasts: some View {
        List {
            ForEach(viewModel.results.compactMap { $0 as? Forecast }) { forecast in
                ForecastRow(forecast: forecast)
            }
        }
        .scrollContentBackground(.hidden)
    }
}

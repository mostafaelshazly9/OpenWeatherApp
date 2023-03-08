//
//  ForecastView.swift
//  OpenWeatherApp
//
//  Created by Mostafa Elshazly on 07/03/2023.
//

import SwiftUI

struct ForecastView: View {

    private let textFieldHeight = 48.0
    private let textFieldHorizontalPadding = 35.0
    private let iconPadding = 8.0
    private let searchButtonCornerRadius = 25.0
    private let roundedRectangleCornerRadius = 5.0
    private let roundedRectangleLineWidth = 1.5

    @StateObject var viewModel = ForecastVM()
    @State var isShowingInfoPopup = false

    var body: some View {
        BaseWeatherSearchView<ForecastVM, AnyView>(viewModel: viewModel, lower: { AnyView(forecasts) })
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
            ForEach(viewModel.forecasts.compactMap { $0 as? Forecast }) { forecast in
                ForecastRow(forecast: forecast)
            }
        }
        .scrollContentBackground(.hidden)
    }
}

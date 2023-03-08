//
//  ForecastView.swift
//  OpenWeatherApp
//
//  Created by Mostafa Elshazly on 07/03/2023.
//

import SwiftUI

struct ForecastView: View {

    var id: String = {
        UUID().uuidString
    }()

    @StateObject var viewModel = ForecastVM()
    @Binding var path: [Int]

    var body: some View {
        BaseWeatherSearchView<ForecastVM, AnyView>(viewModel: viewModel, upper: {
            AnyView(Button("Go to Dashboard") {
                path.removeLast(path.count)
            }
                .modifier(WeatherSearchButtonStyle())
            )
        }, lower: { AnyView(forecasts) }
        )
        .onAppear {
            viewModel.viewDidAppear()
        }
        .navigationTitle("Forecast")
        .navigationBarBackButtonHidden()
    }
}

struct ForecastView_Previews: PreviewProvider {
    @State static var path = [Int]()
    static var previews: some View {
        ForecastView(path: $path)
    }
}

// MARK: UI components
extension ForecastView {

    var forecasts: some View {
        VStack {
            HStack {
                Button(action: {
                    viewModel.didTapFilter24h()
                }, label: {
                    Text("Filter 24h")
                })
                .modifier(WeatherSearchButtonStyle())

                Button(action: {
                    viewModel.didTapFilter48h()
                }, label: {
                    Text("Filter 48h")
                })
                .modifier(WeatherSearchButtonStyle())
            }
            List {
                ForEach(viewModel.results.compactMap { $0 as? Forecast }) { forecast in
                    ForecastRow(forecast: forecast)
                }
            }
            .scrollContentBackground(.hidden)
        }
    }
}

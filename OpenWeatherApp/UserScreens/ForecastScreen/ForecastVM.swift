//
//  ForecastVM.swift
//  OpenWeatherApp
//
//  Created by Mostafa Elshazly on 07/03/2023.
//

import Foundation

class ForecastVM: ObservableObject {

    @Published var query = ""
    @Published var forecasts: [Forecast] = []

    func didTapSearchButton() {
        // TODO: parse query then choose
        if let lat = query.replacingOccurrences(of: " ", with: "").components(separatedBy: ",").first,
           let lon = query.replacingOccurrences(of: " ", with: "").components(separatedBy: ",").last,
           (Double(lat) != nil) && (Double(lon) != nil) {
            Task {
                do {
                    let response = try await OpenWeatherService.fetchWeatherForecast(lat: String(lat), lon: String(lon))
                    await setForeCastsFrom(response)
                } catch let error {
                    print(error)
                }
            }
        }
    }

    @MainActor
    fileprivate func setForeCastsFrom(_ response: WeatherForecastResponse) {
        forecasts = response.list.compactMap { Forecast(from: $0) }
    }
}

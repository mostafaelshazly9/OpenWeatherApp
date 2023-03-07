//
//  ForecastVM.swift
//  OpenWeatherApp
//
//  Created by Mostafa Elshazly on 07/03/2023.
//

import Foundation

class ForecastVM: ObservableObject {

    @Published var query = ""

    func didTapSearchButton() {
        // TODO: parse query then choose
        if let lat = query.components(separatedBy: ",").first,
           let lon = query.components(separatedBy: ",").last,
           Double(lat) != nil,
           Double(lon) != nil {
            Task {
                do {
                    try await OpenWeatherService.fetchWeatherForecast(lat: String(lat), lon: String(lon))
                } catch let error {
                    print(error)
                }
            }
        }
    }
}

//
//  UserDefaultsService.swift
//  OpenWeatherApp
//
//  Created by Mostafa Elshazly on 08/03/2023.
//

import Foundation

class UserDefaultsService {

    private let defaults = UserDefaults.standard

    static var shared = UserDefaultsService()

    private init() {}

    func saveForecastQuery(_ query: String) {
        var array = retrieveLast5ForecastQueries()
        if let index = array.firstIndex(of: query) {
            array.remove(at: index)
        }
        array.append(query)

        defaults.set(array, forKey: "ForecastQueries")
        maintainLengthOf5ForecastQueries(array)
    }

    func retrieveLast5ForecastQueries() -> [String] {
        defaults.stringArray(forKey: "ForecastQueries") ?? []
    }

    func maintainLengthOf5ForecastQueries(_ queries: [String]) {
        guard queries.count > 5 else { return }
        var newArray = queries
        for _ in 0..<(queries.count - 5) {
            newArray.remove(at: 0)
        }
        defaults.set(newArray, forKey: "ForecastQueries")
    }
}

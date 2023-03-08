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

    func saveQuery(_ query: String) {
        var array = retrieveLastNQueries(1000)
        if let index = array.firstIndex(of: query) {
            array.remove(at: index)
        }
        array.append(query)

        defaults.set(array, forKey: "Queries")
        maintainLengthOf10ForecastQueries(array)
    }

    func retrieveLastNQueries(_ number: Int) -> [String] {
        Array(defaults.stringArray(forKey: "Queries")?.suffix(number) ?? [])
    }

    func maintainLengthOf10ForecastQueries(_ queries: [String]) {
        guard queries.count > 10 else { return }
        var newArray = queries
        for _ in 0..<(queries.count - 10) {
            newArray.remove(at: 0)
        }
        defaults.set(newArray, forKey: "Queries")
    }
}

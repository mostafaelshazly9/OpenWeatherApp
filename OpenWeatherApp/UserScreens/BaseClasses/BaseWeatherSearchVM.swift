//
//  BaseWeatherSearchVM.swift
//  OpenWeatherApp
//
//  Created by Mostafa Elshazly on 08/03/2023.
//

import Foundation
import CoreLocation

protocol WeatherSearchVMProtocol: AnyObject, ObservableObject {

    var query: String { get set }
    var queryPublished: Published<String> { get }
    var queryPublisher: Published<String>.Publisher { get }

    var results: [any WeatherPresentableProtocol] { get set }
    var resultsPublished: Published<[any WeatherPresentableProtocol]> { get }
    var resultsPublisher: Published<[any WeatherPresentableProtocol]>.Publisher { get }

    var previousQueries: [String] { get set }
    var previousQueriesPublished: Published<[String]> { get }
    var previousQueriesPublisher: Published<[String]>.Publisher { get }

    var isShowingOldQueries: Bool { get set }
    var isShowingOldQueriesPublished: Published<Bool> { get }
    var isShowingOldQueriesPublisher: Published<Bool>.Publisher { get }

    func viewDidAppear()
    func didTapSearchButton()
    func didTapOldQueriesButton()
    func loadPreviousQueries() -> [String]
    func didTapMapPinIcon()
    func searchForQuery()
    func runWeatherFunctionByLatLon()
    func runWeatherFunctionByZipCountryCodes()
    func runWeatherFunctionByCity()
    func didSelectQuery(_ query: String)
}

extension WeatherSearchVMProtocol {

    func viewDidAppear() {}
}

class BaseWeatherSearchVM: WeatherSearchVMProtocol {

    @Published var query = ""
    var queryPublished: Published<String> { _query }
    var queryPublisher: Published<String>.Publisher { $query }

    @Published var results: [any WeatherPresentableProtocol] = []
    var resultsPublished: Published<[any WeatherPresentableProtocol]> { _results }
    var resultsPublisher: Published<[any WeatherPresentableProtocol]>.Publisher { $results }

    @Published var previousQueries: [String] = []
    var previousQueriesPublished: Published<[String]> { _previousQueries }
    var previousQueriesPublisher: Published<[String]>.Publisher { $previousQueries }

    @Published var isShowingOldQueries = false
    var isShowingOldQueriesPublished: Published<Bool> { _isShowingOldQueries }
    var isShowingOldQueriesPublisher: Published<Bool>.Publisher { $isShowingOldQueries }

    var queryTask: Task<(), Never>?
    private let manager = CLLocationManager()
    private var delegate: CoreLocationDelegate?

    init(query: String = "", delegate: CoreLocationDelegate? = nil) {
        self.query = query
        self.delegate = delegate
    }

    func didTapSearchButton() {
        cancelQueryTask()
        isShowingOldQueries = false
        searchForQuery()
    }

    func didTapOldQueriesButton() {
        cancelQueryTask()
        previousQueries = loadPreviousQueries()
        isShowingOldQueries = true
    }

    func loadPreviousQueries() -> [String] {
        fatalError("Must override in subclasses")
    }

    func didSelectQuery(_ query: String) {
        self.query = query
        isShowingOldQueries = false
        searchForQuery()
    }

    func didTapMapPinIcon() {
        Task {
            do {
                let location: CLLocation = try await
                withCheckedThrowingContinuation { [weak self] continuation in
                    self?.delegate = CoreLocationDelegate(manager: manager, continuation: continuation)
                }
                await setQuery(to: "\(location.coordinate.latitude),\(location.coordinate.longitude)")
            } catch let error {
                print(error)
            }
        }
    }

    func searchForQuery() {
        Task {
            await resetResults()

            if isValidLatLong() {
                runWeatherFunctionByLatLon()
            } else if isValidZipCountryCodes() {
                runWeatherFunctionByZipCountryCodes()
            } else {
                runWeatherFunctionByCity()
            }
        }
    }

    func runWeatherFunctionByLatLon() {
        fatalError("Must override in subclasses")
    }

    func runWeatherFunctionByZipCountryCodes() {
        fatalError("Must override in subclasses")
    }

    func runWeatherFunctionByCity() {
        fatalError("Must override in subclasses")
    }

    @MainActor
    func setQuery(to newQuery: String) {
        query = newQuery
    }

    @MainActor
    func setForecastsFrom(_ response: WeatherForecastResponse) {
        results = response.list.compactMap { Forecast(from: $0) }
    }

    @MainActor
    func setForecastsFrom(_ response: CurrentWeatherResponse) {
        results = [CurrentWeather(from: response)]
    }

    @MainActor
    func resetResults() {
        results = []
    }

    func cancelQueryTask() {
        queryTask?.cancel()
        queryTask = nil
    }

    // MARK: Latitude and Longitude

    func isValidLatLong() -> Bool {
        if let lat = query.replacingOccurrences(of: " ", with: "").components(separatedBy: ",").first,
           let lon = query.replacingOccurrences(of: " ", with: "").components(separatedBy: ",").last,
           (Double(lat) != nil) && (Double(lon) != nil) {
            return true
        } else {
            return false
        }
    }

    func getLatLongFromQuery() -> (lat: String, lon: String) {
        if let lat = query.replacingOccurrences(of: " ", with: "").components(separatedBy: ",").first,
           let lon = query.replacingOccurrences(of: " ", with: "").components(separatedBy: ",").last {
            return (lat, lon)
        }
        return ("", "")
    }

    // MARK: Zip code

    func isValidZipCountryCodes() -> Bool {
        if let zipCode = query.replacingOccurrences(of: " ", with: "").components(separatedBy: ",").first,
           query.replacingOccurrences(of: " ", with: "").components(separatedBy: ",").last != nil,
           let intZipCode = Int(zipCode),
           intZipCode > 0 {
            return true
        } else {
            return false
        }
    }

    func getZipCountryCodesFromQuery() -> (zip: String, country: String) {
        if let zipCode = query.replacingOccurrences(of: " ", with: "").components(separatedBy: ",").first,
           let countryCode = query.replacingOccurrences(of: " ", with: "").components(separatedBy: ",").last {
            return (zipCode, countryCode.lowercased())
        }
        return ("", "")
    }
}

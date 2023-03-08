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

    var resultsFilterMethod: ((any WeatherPresentableProtocol) -> Bool) = { _ in true }
    private var weatherForecastResponse: WeatherForecastResponse?

    var queryTask: Task<(), Never>?
    private let manager = CLLocationManager()
    private var delegate: CoreLocationDelegate?

    init(query: String = "", delegate: CoreLocationDelegate? = nil) {
        self.query = query
        self.delegate = delegate
    }

    func viewDidAppear() {
        if let lastQuery = loadPreviousQueries().first {
            Task {
                await setQuery(to: lastQuery)
                searchForQuery()
            }
        }
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

            if query.isValidLatLong() {
                runWeatherFunctionByLatLon()
            } else if query.isValidZipCountryCodes() {
                runWeatherFunctionByZipCountryCodes()
            } else {
                runWeatherFunctionByCity()
            }
        }
    }

    @MainActor
    func applyFilterFunction(_ function: @escaping ((any WeatherPresentableProtocol) -> Bool) = { _ in true }) {
        if let response = weatherForecastResponse?.list.compactMap({ Forecast(from: $0) }) {
            results = response.filter(function)
        }
        resultsFilterMethod = function
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
        weatherForecastResponse = response
        results = response.list.compactMap { Forecast(from: $0) }.filter(resultsFilterMethod)
    }

    @MainActor
    func setForecastsFrom(_ response: CurrentWeatherResponse) {
        results = [CurrentWeather(from: response)]
    }

    @MainActor
    func resetResults() {
        results = []
        applyFilterFunction()
    }

    func cancelQueryTask() {
        queryTask?.cancel()
        queryTask = nil
    }
}

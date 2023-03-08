//
//  WeatherPresentableProtocol.swift
//  OpenWeatherApp
//
//  Created by Mostafa Elshazly on 08/03/2023.
//

import Foundation

protocol WeatherPresentableProtocol: Identifiable {

    var id: Double { get }

    var date: Double { get set }
    var isNight: Bool { get set }
    var title: String { get set }
    var description: String { get set }
    var icon: String { get set }
    var temp: Double? { get set }
    var feelsLike: Double? { get set }
}

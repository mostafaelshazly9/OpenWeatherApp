//
//  CurrentWeatherData+CoreDataProperties.swift
//  OpenWeatherApp
//
//  Created by Mostafa Elshazly on 08/03/2023.
//
//

import Foundation
import CoreData

extension CurrentWeatherData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CurrentWeatherData> {
        return NSFetchRequest<CurrentWeatherData>(entityName: "CurrentWeatherData")
    }

    @NSManaged public var date: Double
    @NSManaged public var dateStored: Date?
    @NSManaged public var feelsLike: Double
    @NSManaged public var icon: String?
    @NSManaged public var isNight: Bool
    @NSManaged public var temp: Double
    @NSManaged public var title: String?
    @NSManaged public var weatherDescription: String?
    @NSManaged public var query: String?

}

extension CurrentWeatherData: Identifiable {

}

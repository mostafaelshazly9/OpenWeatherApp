//
//  CurrentWeatherData+CoreDataClass.swift
//  OpenWeatherApp
//
//  Created by Mostafa Elshazly on 08/03/2023.
//
//

import Foundation
import CoreData

public class CurrentWeatherData: NSManagedObject {

    func createCurrentWeather() -> CurrentWeather {
        CurrentWeather(date: date,
                       isNight: isNight,
                       title: title ?? "",
                       description: weatherDescription ?? "",
                       icon: icon ?? "",
                       temp: temp,
                       feelsLike: feelsLike)
    }

    static func saveNew(query: String, currentWeather: CurrentWeather) {
        deleteQueryIfExists(query)
        let object = CurrentWeatherData(context: PersistenceController.shared.container.viewContext)
        object.query = query
        object.date = currentWeather.date
        object.dateStored = Date()
        object.feelsLike = currentWeather.feelsLike ?? 0
        object.temp = currentWeather.temp ?? 0
        object.icon = currentWeather.icon
        object.isNight = currentWeather.isNight
        object.title = currentWeather.title
        object.weatherDescription = currentWeather.weatherDescription 
        try? PersistenceController.shared.container.viewContext.save()
        deleteOldData()
    }

    static func getCurrentWeatherData(for query: String) -> CurrentWeatherData? {
        deleteOldData()
        let predicate = NSPredicate(format: "query == %@", query)
        let fetchRequest: NSFetchRequest<CurrentWeatherData> = CurrentWeatherData.fetchRequest()
        fetchRequest.predicate = predicate
        fetchRequest.returnsObjectsAsFaults = false

        let context = PersistenceController.shared.container.viewContext

        return try? context.fetch(fetchRequest).first
    }

    static private func deleteOldData() {
        getOldData().forEach { PersistenceController.shared.container.viewContext.delete($0) }
        try? PersistenceController.shared.container.viewContext.save()

        let sortDescriptor = NSSortDescriptor(key: #keyPath(CurrentWeatherData.dateStored),
                                              ascending: false)
        let fetchRequest: NSFetchRequest<CurrentWeatherData> = CurrentWeatherData.fetchRequest()
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchRequest.returnsObjectsAsFaults = false

        let context = PersistenceController.shared.container.viewContext

        if let objects = try? context.fetch(fetchRequest) {
            let objectCount = objects.count
            if objectCount > 5 {
                for index in stride(from: objectCount, to: 5, by: -1) {
                    PersistenceController.shared.container.viewContext.delete(objects[index])
                }
            }
        }
    }

    static private func getOldData() -> [CurrentWeatherData] {
        let nextDate = Date().addingTimeInterval(-300)
        let predicate = NSPredicate(format: "dateStored < %@", nextDate as NSDate)
        let fetchRequest: NSFetchRequest<CurrentWeatherData> = CurrentWeatherData.fetchRequest()
        fetchRequest.predicate = predicate
        fetchRequest.returnsObjectsAsFaults = false

        let context = PersistenceController.shared.container.viewContext

        let objects = try? context.fetch(fetchRequest)
        return objects ?? []
    }

    static private func deleteQueryIfExists(_ query: String) {
        let predicate = NSPredicate(format: "query == %@", query)
        let fetchRequest: NSFetchRequest<CurrentWeatherData> = CurrentWeatherData.fetchRequest()
        fetchRequest.predicate = predicate
        fetchRequest.returnsObjectsAsFaults = false

        let context = PersistenceController.shared.container.viewContext

        let objects = try? context.fetch(fetchRequest)
        (objects ?? []).forEach { PersistenceController.shared.container.viewContext.delete($0) }
        try? PersistenceController.shared.container.viewContext.save()
    }
}

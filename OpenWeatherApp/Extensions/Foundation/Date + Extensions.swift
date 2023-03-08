//
//  Date + Extensions.swift
//  OpenWeatherApp
//
//  Created by Mostafa Elshazly on 08/03/2023.
//

import Foundation

extension Date {

    func localFromUTC() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short

        let stringDate = dateFormatter.string(from: self)
        if let date = dateFormatter.date(from: stringDate) {
            dateFormatter.timeZone = .current
            return dateFormatter.string(from: date)
        }
        return nil
    }

    struct SubtractionDate {
        var month: Int?
        var day: Int?
        var hour: Int?
        var minute: Int?
        var second: Int?
    }

    static func - (recent: Date, previous: Date) -> SubtractionDate {
        let day = Calendar.current.dateComponents([.day], from: previous, to: recent).day
        let month = Calendar.current.dateComponents([.month], from: previous, to: recent).month
        let hour = Calendar.current.dateComponents([.hour], from: previous, to: recent).hour
        let minute = Calendar.current.dateComponents([.minute], from: previous, to: recent).minute
        let second = Calendar.current.dateComponents([.second], from: previous, to: recent).second

        return SubtractionDate(month: month, day: day, hour: hour, minute: minute, second: second)
    }
}

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
}

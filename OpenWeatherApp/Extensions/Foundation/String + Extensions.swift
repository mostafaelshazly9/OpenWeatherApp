//
//  String + Extensions.swift
//  OpenWeatherApp
//
//  Created by Mostafa Elshazly on 08/03/2023.
//

import Foundation

extension String {

    // MARK: Latitude and Longitude

    func isValidLatLong() -> Bool {
        if let lat = self.replacingOccurrences(of: " ", with: "").components(separatedBy: ",").first,
           let lon = self.replacingOccurrences(of: " ", with: "").components(separatedBy: ",").last,
           (Double(lat) != nil) && (Double(lon) != nil) {
            return true
        } else {
            return false
        }
    }

    func getLatLongFromQuery() -> (lat: String, lon: String) {
        if let lat = self.replacingOccurrences(of: " ", with: "").components(separatedBy: ",").first,
           let lon = self.replacingOccurrences(of: " ", with: "").components(separatedBy: ",").last {
            return (lat, lon)
        }
        return ("", "")
    }

    // MARK: Zip code

    func isValidZipCountryCodes() -> Bool {
        if let zipCode = self.replacingOccurrences(of: " ", with: "").components(separatedBy: ",").first,
           self.replacingOccurrences(of: " ", with: "").components(separatedBy: ",").last != nil,
           let intZipCode = Int(zipCode),
           intZipCode > 0 {
            return true
        } else {
            return false
        }
    }

    func getZipCountryCodesFromQuery() -> (zip: String, country: String) {
        if let zipCode = self.replacingOccurrences(of: " ", with: "").components(separatedBy: ",").first,
           let countryCode = self.replacingOccurrences(of: " ", with: "").components(separatedBy: ",").last {
            return (zipCode, countryCode.lowercased())
        }
        return ("", "")
    }
}

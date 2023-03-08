//
//  CoreLocationDelegate.swift
//  OpenWeatherApp
//
//  Created by Mostafa Elshazly on 08/03/2023.
//

import Foundation
import CoreLocation

class CoreLocationDelegate: NSObject, CLLocationManagerDelegate {

    typealias LocationContinuation = CheckedContinuation<CLLocation, Error>
    private var continuation: LocationContinuation?

    enum CoreLocationError: String, Error {
        case notAuthorized = "The app isn't authorized to use location data"
    }

    init(manager: CLLocationManager, continuation: LocationContinuation) {
        self.continuation = continuation
        super.init()
        manager.delegate = self
        manager.requestWhenInUseAuthorization()
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .notDetermined:
            break
        case .authorizedAlways, .authorizedWhenInUse:
            manager.startUpdatingLocation()
        default:
            continuation?.resume(
                throwing: CoreLocationError.notAuthorized
            )
            continuation = nil
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        continuation?.resume(returning: location)
        continuation = nil
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        continuation?.resume(throwing: error)
        continuation = nil
    }
}

//
//  LocationStorageManager.swift
//  MapWidget
//
//  Created by Felix Mau on 28.11.20.
//  Copyright © 2020 Felix Mau. All rights reserved.
//

import Foundation
import CoreLocation

protocol LocationStorageManaging {
    func set(location: CLLocation, forKey key: String)
    func location(forKey key: String) -> CLLocation?
}

/// Based on https://stackoverflow.com/a/18910861/3532505
extension UserDefaults: LocationStorageManaging {
    // MARK: - Config

    private enum Config {
        static let latitudeKey = "latitude"
        static let longitudeKey = "longitude"
    }

    // MARK: - Public methods

    func set(location: CLLocation, forKey key: String) {
        let locationAsDictionary = [
            Config.latitudeKey: NSNumber(value: location.coordinate.latitude),
            Config.longitudeKey: NSNumber(value: location.coordinate.longitude)
        ]

        set(locationAsDictionary, forKey: key)
    }

    func location(forKey key: String) -> CLLocation? {
        guard
            let locationAsDictionary = object(forKey: key) as? [String: NSNumber],
            let latitude = locationAsDictionary[Config.latitudeKey]?.doubleValue,
            let longitude = locationAsDictionary[Config.longitudeKey]?.doubleValue
        else {
            return nil
        }

        return CLLocation(latitude: latitude, longitude: longitude)
    }
}

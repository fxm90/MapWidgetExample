//
//  UserLocation.swift
//  MapWidget
//
//  Created by Felix Mau on 27.11.20.
//  Copyright © 2020 Felix Mau. All rights reserved.
//

import Foundation
import CoreLocation

enum UserLocation {
    /// The associated location is the actual current user location.
    case currentLocation(CLLocation)

    /// The associated location is the last-known user location.
    case lastKnownLocation(CLLocation)

    // MARK: - Public properties

    var coordinate: CLLocationCoordinate2D {
        switch self {
        case let .currentLocation(userLocation),
             let .lastKnownLocation(userLocation):
            return userLocation.coordinate
        }
    }
}

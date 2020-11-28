//
//  MapSnapshot.swift
//  MapWidget
//
//  Created by Felix Mau on 27.11.20.
//  Copyright © 2020 Felix Mau. All rights reserved.
//

import SwiftUI

struct MapSnapshot {
    /// The resolved user location.
    let userLocation: UserLocation

    /// The map-snapshot image for the resolved user location.
    let image: Image
}

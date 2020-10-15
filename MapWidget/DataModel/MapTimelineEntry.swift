//
//  MapTimelineEntry.swift
//  MapWidget
//
//  Created by Felix Mau on 15.10.20.
//  Copyright © 2020 Felix Mau. All rights reserved.
//

import WidgetKit
import SwiftUI

struct MapTimelineEntry: TimelineEntry {
    /// The date to display the widget. This property is required by the protocol `TimelineEntry`.
    let date: Date

    /// The map-image to display. In case the `MKMapSnapshotter` failed to create an image this property is `nil`.
    let mapImage: Image?
}

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

    /// The result of the location manager and map snapshotter, which is either the image of the map to display or
    /// the error that occurred.
    let mapImageResult: Result<Image, Error>
}

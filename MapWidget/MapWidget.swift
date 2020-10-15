//
//  MapWidget.swift
//  MapWidget
//
//  Created by Felix Mau on 15.10.20.
//  Copyright © 2020 Felix Mau. All rights reserved.
//

import WidgetKit
import SwiftUI

@main
struct MapWidget: Widget {
    // MARK: - Config

    private enum Config {
        ///
        static let displayName = "Map Widget"

        ///
        static let description = "This is an example widget showing a map."

        ///
        static let supportedFamilies: [WidgetFamily] = [.systemSmall, .systemMedium]
    }

    // MARK: - Public properties

    let kind: String = "MapWidget"

    // MARK: - Dependencies

    private let locationManager = LocationManager()
    private let mapSnapshotManager = MapSnapshotManager()

    // MARK: - Render

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind,
                            provider: MapTimelineProvider(locationManager: locationManager,
                                                          mapSnapshotManager: mapSnapshotManager)) { entry in
            MapWidgetView(entry: entry)
        }
        .configurationDisplayName(Config.displayName)
        .description(Config.description)
        .supportedFamilies(Config.supportedFamilies)
    }
}

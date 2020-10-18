//
//  MapTimelineProvider.swift
//  MapWidget
//
//  Created by Felix Mau on 15.10.20.
//  Copyright © 2020 Felix Mau. All rights reserved.
//

import WidgetKit
import SwiftUI

struct MapTimelineProvider: TimelineProvider {
    // MARK: - Config

    private enum Config {
        /// Update widget after one minute to always show an up to date user location.
        static let refreshTimeInterval: TimeInterval = 60
    }

    // MARK: - Types

    enum MapImageResultError: Error {
        /// The timeline provider asked for a placeholder synchronously.
        /// Therefore we can't retrieve a real user-location and map snapshot.
        case placeholder
    }

    // MARK: - Dependencies

    private let locationManager: LocationManager
    private let mapSnapshotManager: MapSnapshotManager

    // MARK: - Initializer

    init(locationManager: LocationManager, mapSnapshotManager: MapSnapshotManager) {
        self.locationManager = locationManager
        self.mapSnapshotManager = mapSnapshotManager
    }

    // MARK: - Public methods

    func placeholder(in _: Context) -> MapTimelineEntry {
        MapTimelineEntry(date: Date(),
                         mapImageResult: .failure(MapImageResultError.placeholder))
    }

    func getSnapshot(in _: Context,
                     completion: @escaping (MapTimelineEntry) -> Void) {
        mapSnapshotForCurrentUserLocation { mapImageResult in
            let mapTimelineEntry = MapTimelineEntry(date: Date(),
                                                    mapImageResult: mapImageResult)
            completion(mapTimelineEntry)
        }
    }

    func getTimeline(in _: Context,
                     completion: @escaping (Timeline<MapTimelineEntry>) -> Void) {
        mapSnapshotForCurrentUserLocation { mapImageResult in
            // > Because our app can’t “predict” its future state like a Weather app, creating a timeline with a single entry that
            // > should be displayed immediately will suffice. This can be done by setting the entry’s date to the current Date().
            // https://medium.com/better-programming/how-to-create-widgets-in-ios-14-8cf58d34ce89
            let mapTimelineEntry = MapTimelineEntry(date: Date(),
                                                    mapImageResult: mapImageResult)

            let refreshDate = Date(timeIntervalSinceNow: Config.refreshTimeInterval)
            let timeline = Timeline(entries: [mapTimelineEntry],
                                    policy: .after(refreshDate))

            completion(timeline)
        }
    }

    // MARK: - Private methods

    private func mapSnapshotForCurrentUserLocation(_ completionHandler: @escaping (Result<Image, Error>) -> Void) {
        "Start requesting map snapshot for user location..."
            .log(level: .info)

        locationManager.requestLocation { locationResult in
            switch locationResult {
            case let .success(userLocation):
                "Received user location: \(userLocation.coordinate)"
                    .log(level: .info)

                mapSnapshotManager.snapshot(at: userLocation.coordinate) { mapSnapshotResult in
                    switch mapSnapshotResult {
                    case let .success(mapImage):
                        "Successfully created map image.".log(level: .info)
                        completionHandler(.success(mapImage))

                    case let .failure(error):
                        "Failed to get map snapshot: \(error.localizedDescription)".log(level: .error)
                        completionHandler(.failure(error))
                    }
                }

            case let .failure(error):
                "Failed to get user location: \(error.localizedDescription)".log(level: .error)
                completionHandler(.failure(error))
            }
        }
    }
}

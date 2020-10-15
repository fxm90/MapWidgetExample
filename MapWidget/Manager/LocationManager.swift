//
//  LocationManager.swift
//  MapWidget
//
//  Created by Felix Mau on 15.10.20.
//  Copyright © 2020 Felix Mau. All rights reserved.
//

import Foundation
import CoreLocation

/// Based on: https://gist.github.com/fxm90/8b6c9753f12fcf19991f6c3f0cd635d3
final class LocationManager: NSObject {
    // MARK: - Types

    typealias RequestLocationCompletionHandler = (Result<CLLocation, Error>) -> Void

    // MARK: - Private properties

    private var requestLocationCompletionHandlers = [RequestLocationCompletionHandler]()

    // MARK: - Dependencies

    ///
    private var locationManager: CLLocationManager?

    // MARK: - Initializer

    override init() {
        super.init()

        setupLocationManager()
    }

    // MARK: - Public methods

    func requestLocation(_ completionHandler: @escaping RequestLocationCompletionHandler) {
        requestLocationCompletionHandlers.append(completionHandler)

        guard let locationManager = locationManager else {
            "Expect to have a valid `locationManager` at this point!"
                .log(level: .error)

            return
        }

        if locationManager.authorizationStatus.isAuthorized {
            locationManager.requestLocation()
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
    }

    // MARK: - Private properties

    private func setupLocationManager() {
        // We have to explicitly make sure to intialize the location manger on the main thread.
        DispatchQueue.main.async {
            let locationManager = CLLocationManager()
            self.locationManager = locationManager

            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.activityType = .otherNavigation

            locationManager.delegate = self
        }
    }
}

// MARK: - CLLocationManagerDelegate

extension LocationManager: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        guard manager.authorizationStatus.isAuthorized else {
            // Ignore changes where we loose authorization.
            return
        }

        guard !requestLocationCompletionHandlers.isEmpty else {
            // Ignore changes where we don't have any pending completion handlers.
            return
        }

        locationManager?.requestLocation()
    }

    func locationManager(_: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {
            // > If updates were deferred or if multiple locations arrived before they could be delivered, the array may contain additional entries.
            // > The objects in the array are organized in the order in which they occurred. Therefore, the most recent location update is at the end
            // > of the array.
            // https://developer.apple.com/documentation/corelocation/cllocationmanagerdelegate/1423615-locationmanager
            return
        }

        requestLocationCompletionHandlers.forEach { $0(.success(location)) }
        requestLocationCompletionHandlers.removeAll()
    }

    func locationManager(_: CLLocationManager, didFailWithError error: Error) {
        requestLocationCompletionHandlers.forEach { $0(.failure(error)) }
        requestLocationCompletionHandlers.removeAll()
    }
}

// MARK: - Helpers

private extension CLAuthorizationStatus {
    ///
    var isAuthorized: Bool {
        isAny(of: .authorizedAlways, .authorizedWhenInUse)
    }
}

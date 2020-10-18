//
//  LocationManager.swift
//  MapWidget
//
//  Created by Felix Mau on 15.10.20.
//  Copyright © 2020 Felix Mau. All rights reserved.
//

import Foundation
import CoreLocation

final class LocationManager: NSObject {
    // MARK: - Config

    private enum Config {
        /// The type of user activity associated with the location updates.
        static let activityType: CLActivityType = .otherNavigation
    }

    // MARK: - Types

    typealias RequestLocationCompletionHandler = (Result<CLLocation, Error>) -> Void

    // MARK: - Private properties

    private var requestLocationCompletionHandlers = [RequestLocationCompletionHandler]()

    // MARK: - Dependencies

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
            "Expect to have a valid `locationManager` instance at this point!"
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
        // This is not happening per default when instantiating the widget.
        DispatchQueue.main.async {
            let locationManager = CLLocationManager()
            self.locationManager = locationManager

            locationManager.activityType = Config.activityType
            locationManager.delegate = self
        }
    }

    private func resolveRequestLocationCompletionHandlers(with result: Result<CLLocation, Error>) {
        requestLocationCompletionHandlers.forEach { $0(result) }
        requestLocationCompletionHandlers.removeAll()
    }
}

// MARK: - CLLocationManagerDelegate

extension LocationManager: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        guard manager.authorizationStatus.isAuthorized else {
            // Ignore authorization changes where we loose access to location data.
            return
        }

        guard !requestLocationCompletionHandlers.isEmpty else {
            // Ignore changes where we don't have any pending completion handlers.
            return
        }

        locationManager?.requestLocation()
    }

    func locationManager(_: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // We explicitly ask for the `first` location here, as with `requestLocation()` only one location fix is reported to the delegate.
        // https://developer.apple.com/documentation/corelocation/cllocationmanager/1620548-requestlocation
        guard let userLocation = locations.first else {
            return
        }

        resolveRequestLocationCompletionHandlers(with: .success(userLocation))
    }

    func locationManager(_: CLLocationManager, didFailWithError error: Error) {
        resolveRequestLocationCompletionHandlers(with: .failure(error))
    }
}

// MARK: - Helpers

private extension CLAuthorizationStatus {
    /// Boolean flag whether we're authorized to access location data.
    var isAuthorized: Bool {
        isAny(of: .authorizedAlways, .authorizedWhenInUse)
    }
}

//
//  MapWidgetView.swift
//  MapWidget
//
//  Created by Felix Mau on 15.10.20.
//  Copyright © 2020 Felix Mau. All rights reserved.
//

import WidgetKit
import SwiftUI

struct MapUserLocationView: View {
    // MARK: - Config

    private enum Config {
        /// The size of the blue dot reflecting the user location.
        static let userLocationDotSize: CGFloat = 20
    }

    // MARK: - Public properties

    let mapImage: Image

    // MARK: - Render

    var body: some View {
        ZStack {
            mapImage
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(maxWidth: .infinity, maxHeight: .infinity)

            // The map is centered on the user location, therefore we can simply draw the blue dot in the
            // center of our view to simulate the user coordinate.
            Circle()
                .foregroundColor(Color.blue)
                .overlay(
                    Circle()
                        .stroke(Color.white, lineWidth: 3)
                )
                .frame(width: Config.userLocationDotSize,
                       height: Config.userLocationDotSize)
        }
    }
}

struct MapErrorView: View {
    // MARK: - Config

    private enum Config {
        /// The color to use as a background in case we have an invalid map image.
        static let fallbackColor = Color(red: 225 / 255,
                                         green: 239 / 255,
                                         blue: 210 / 255)
    }

    // MARK: - Public properties

    let errorMessage: String?

    // MARK: - Render

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            Rectangle()
                .foregroundColor(Config.fallbackColor)

            if let errorMessage = errorMessage {
                Text(errorMessage)
                    .font(.footnote)
                    .padding()
            }
        }
    }
}

struct MapWidgetView: View {
    // MARK: - Public properties

    let entry: MapTimelineProvider.Entry

    // MARK: - Render

    var body: some View {
        switch entry.mapImageResult {
        case let .success(mapImage):
            MapUserLocationView(mapImage: mapImage)

        case let .failure(error):
            switch error {
            case MapTimelineProvider.MapImageResultError.placeholder:
                /// The timeline provider asked for a placeholder synchronously.
                /// Therefore we simply show the `MapErrorView` without a specific `errorMessage`.
                MapErrorView(errorMessage: nil)

            default:
                MapErrorView(errorMessage: error.localizedDescription)
            }
        }
    }
}

// MARK: - Preview

#if DEBUG
    struct MapWidgetView_Previews: PreviewProvider {
        static var previews: some View {
            let mapTimelineEntry = MapTimelineEntry(date: Date(),
                                                    mapImageResult: .success(Image("MapApplePark")))

            return Group {
                MapWidgetView(entry: mapTimelineEntry)
                    .previewContext(WidgetPreviewContext(family: .systemSmall))

                MapWidgetView(entry: mapTimelineEntry)
                    .previewContext(WidgetPreviewContext(family: .systemMedium))
            }
        }
    }
#endif

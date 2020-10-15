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

struct MapWidgetView: View {
    // MARK: - Config

    private enum Config {
        /// The color to use as a background in case we have an invalid map image.
        static let fallbackColor = Color(red: 225 / 255,
                                         green: 239 / 255,
                                         blue: 210 / 255)
    }

    // MARK: - Public properties

    let entry: MapTimelineProvider.Entry

    // MARK: - Render

    var body: some View {
        if let mapImage = entry.mapImage {
            MapUserLocationView(mapImage: mapImage)
        } else {
            Rectangle()
                .foregroundColor(Config.fallbackColor)
        }
    }
}

// MARK: - Preview

#if DEBUG
    struct MapWidgetView_Previews: PreviewProvider {
        static var previews: some View {
            let mapTimelineEntry = MapTimelineEntry(date: Date(),
                                                    mapImage: Image("MapHamburg"))

            return Group {
                MapWidgetView(entry: mapTimelineEntry)
                    .previewContext(WidgetPreviewContext(family: .systemSmall))

                MapWidgetView(entry: mapTimelineEntry)
                    .previewContext(WidgetPreviewContext(family: .systemMedium))
            }
        }
    }
#endif

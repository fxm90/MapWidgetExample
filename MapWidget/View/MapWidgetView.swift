//
//  MapWidgetView.swift
//  MapWidget
//
//  Created by Felix Mau on 15.10.20.
//  Copyright © 2020 Felix Mau. All rights reserved.
//

import WidgetKit
import SwiftUI

struct MapWidgetView: View {
    // MARK: - Config

    private enum Config {
        ///
        static let fallbackColor = Color(red: 225 / 255,
                                         green: 239 / 255,
                                         blue: 210 / 255)

        ///
        static let userLocationDotSize: CGFloat = 20
    }

    // MARK: - Public properties

    let entry: MapTimelineProvider.Entry

    // MARK: - Render

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            if let mapImage = entry.mapImage {
                ZStack {
                    mapImage
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)

                    // The map is centered on the user location, therefore we can simply draw the blue dot in the
                    // center of the view to simulate the user coordinate.
                    Circle()
                        .foregroundColor(Color.blue)
                        .overlay(
                            Circle()
                                .stroke(Color.white, lineWidth: 3)
                        )
                        .frame(width: Config.userLocationDotSize,
                               height: Config.userLocationDotSize)
                }
            } else {
                Rectangle()
                    .foregroundColor(Config.fallbackColor)
            }
        }
    }
}

// MARK: - Preview

struct Widget_Previews: PreviewProvider {
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

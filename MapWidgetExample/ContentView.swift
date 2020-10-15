//
//  ContentView.swift
//  MapWidgetExample
//
//  Created by Felix Mau on 15.10.20.
//  Copyright © 2020 Felix Mau. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack(spacing: 8) {
            Text("Nothing to see here.")
                .font(.title)

            Text("Please add the widget to your home screen and allow location access.")
        }
        .multilineTextAlignment(.center)
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

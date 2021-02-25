//
//  ARFApp.swift
//  ARF
//
//  Created by William Moten on 2/21/21.
//

import SwiftUI

@main
struct ARFApp: App {
    @StateObject var placementSettings = PlacementSettings()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(placementSettings)
        }
    }
}

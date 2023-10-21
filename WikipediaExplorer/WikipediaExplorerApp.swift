//
//  WikipediaExplorerApp.swift
//  WikipediaExplorer
//

import ComposableArchitecture
import SwiftUI
import XCTestDynamicOverlay

@main
struct WikipediaExplorerApp: App {
    var body: some Scene {
        WindowGroup {
            if !_XCTIsTesting { // Start app only if its not a test
                PlacesListView(store: Store(initialState: .default) {
                    PlacesListFeature()
                })
            }
        }
    }
}

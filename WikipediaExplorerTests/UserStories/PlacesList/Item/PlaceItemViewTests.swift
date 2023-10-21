//
//  PlaceItemViewTests.swift
//  WikipediaExplorerTests
//

import SnapshotTesting
import SwiftUI
import XCTest
@testable import WikipediaExplorer

@MainActor
final class PlaceItemViewTests: XCTestCase {
    func test_view_render() throws {
        let place = PlaceItem(index: 0,
                              name: "Amsterdam",
                              coordinates: .init(latitude: 3.45645,
                                                 longitude: -122.099123))
        
        let view = PlaceItemView(place: place)
        let viewController = UIHostingController(rootView: view)
        
        TestConfig.viewConfigs.forEach { config in
            assertSnapshot(of: viewController, as: .image(on: config))
        }
    }
}

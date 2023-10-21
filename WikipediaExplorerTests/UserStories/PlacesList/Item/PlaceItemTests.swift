//
//  PlaceItemTests.swift
//  WikipediaExplorerTests
//

import XCTest
@testable import WikipediaExplorer

final class PlaceItemTests: XCTestCase {
    func test_formattedCoordinates() {
        let place = PlaceItem(index: 0,
                              name: "Amsterdam",
                              coordinates: .init(latitude: 3.45645,
                                                 longitude: -122.099123))
        XCTAssertEqual(place.formattedCoordinates, "3.46 -122.10")
    }
}

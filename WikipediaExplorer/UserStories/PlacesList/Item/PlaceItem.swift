//
//  PlaceItem.swift
//  WikipediaExplorer
//

import CoreLocation
import Foundation

/// Struct to contain data for place item view
struct PlaceItem: Equatable, Identifiable {
    let index: Int
    let name: String
    let coordinates: CLLocationCoordinate2D
    
    var id: Int {
        index
    }
    
    var formattedCoordinates: String {
        String(format: "%0.2f %0.2f", coordinates.latitude, coordinates.longitude)
    }
}

// MARK: - Helpers
extension PlaceItem {
    static let `default`: PlaceItem = .init(index: 0,
                                            name: "",
                                            coordinates: .init())
    
    static let mock: PlaceItem = .init(index: 0,
                                       name: "Amsterdam",
                                       coordinates: .init(latitude: 1.234, longitude: 5.567))
}

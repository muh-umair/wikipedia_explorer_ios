//
//  CLLocationCoordinate2D+.swift
//  WikipediaExplorer
//

import CoreLocation

extension CLLocationCoordinate2D: Equatable {
    /// Equality check
    public static func == (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
    }
}

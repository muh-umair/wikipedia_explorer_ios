//
//  ExternalPlaceDetailHandler.swift
//  WikipediaExplorer
//

import Dependencies
import DependenciesAdditions
import Foundation

/// Errors that can be thrown by ``ExternalPlaceDetailHandler``
enum ExternalPlaceDetailHandlerError: Error, LocalizedError, Equatable {
    case invalidCoordinates
    case cantOpenExternalApp(String)
    
    var errorDescription: String? {
        switch self {
        case .invalidCoordinates:
            return "Invalid latitude/longitude"
            
        case .cantOpenExternalApp(let appName):
            return "Can't open \(appName)"
        }
    }
}

/// External place detail handler to open detail for a place outside the current app.
struct ExternalPlaceDetailHandler {
    var handleCoordinates: (String, String) async throws -> Void
}

/// Wikipedia handler to open detail in wikipedia app
extension ExternalPlaceDetailHandler {
    static let wikipedia: Self = .init { latitude, longitude in
        guard let lat = Double(latitude),
              let long = Double(longitude)
        else {
            throw ExternalPlaceDetailHandlerError.invalidCoordinates
        }
        
        let urlString = "wikipedia://places?WMFCoordinates=\(lat),\(long)"
        @Dependency(\.application) var application
        
        guard let url = URL(string: urlString),
              await application.canOpenURL(url)
        else {
            throw ExternalPlaceDetailHandlerError.cantOpenExternalApp("Wikipedia")
        }
        
        _ = await application.open(url)
    }
}

/// Dependencies for ``ExternalPlaceDetailHandler``
extension ExternalPlaceDetailHandler: DependencyKey {
    static var liveValue: Self { .wikipedia }
}

extension DependencyValues {
    var externalPlaceDetailHandler: ExternalPlaceDetailHandler {
        get { self[ExternalPlaceDetailHandler.self] }
        set { self[ExternalPlaceDetailHandler.self] = newValue }
    }
}

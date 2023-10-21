//
//  PlacesListFeature.swift
//  WikipediaExplorer
//

import ComposableArchitecture
import CoreLocation
import Foundation
import Services
import UIKit

/// Store to support places list view.
struct PlacesListFeature: Reducer {
    // MARK: - State
    struct State: Equatable {
        var isLoading: Bool
        var searchString: String
        var allPlaces: [PlaceItem]
        var filteredPlaces: [PlaceItem]
        var errorMessage: String
        var presentCustomLocationAlert: Bool
        var customLocationLatitude: String
        var customLocationLongitude: String
    }
    
    // MARK: - Actions
    enum Action: Equatable {
        case viewLoaded
        case receivedPlaces([PlaceInfo])
        case receivedError(String)
        case searchChanged(String)
        case errorAlertDismissed
        case onPlaceTapped(PlaceItem)
        case onPresentCustomLocationAlertTapped
        case onCustomLocationAlertDoneTapped
        case onCustomLocationAlertDismissed
        case customLocationLatitudeChanged(String)
        case customLocationLongitudeChanged(String)
    }
    
    // MARK: - Properties
    @Dependency(\.placeInfoService) var placeInfoService
    @Dependency(\.externalPlaceDetailHandler) var externalPlaceDetailHandler
}

// MARK: - Reducer
extension PlacesListFeature {
    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case .viewLoaded:
            state.isLoading = true
            return .run { send in
                do {
                    let places = try await placeInfoService.fetchList()
                    await send(.receivedPlaces(places))
                } catch {
                    await send(.receivedError(error.localizedDescription))
                }
            }
            
        case .searchChanged(let searchString):
            state.searchString = searchString
            state.filteredPlaces = filter(allPlaces: state.allPlaces, searchString: state.searchString)
            return .none
            
            
        case .receivedPlaces(let places):
            state.allPlaces = places.enumerated().map(PlaceItem.init)
            state.filteredPlaces = filter(allPlaces: state.allPlaces, searchString: state.searchString)
            state.isLoading = false
            return .none
            
        case .receivedError(let errorMessage):
            state.errorMessage = errorMessage
            state.isLoading = false
            return .none
            
        case .errorAlertDismissed:
            return .none
            
        case .onPresentCustomLocationAlertTapped:
            state.presentCustomLocationAlert = true
            return .none
            
        case .customLocationLatitudeChanged(let latitude):
            state.customLocationLatitude = latitude
            return .none
            
        case .customLocationLongitudeChanged(let longitude):
            state.customLocationLongitude = longitude
            return .none
            
        case .onCustomLocationAlertDismissed:
            state.customLocationLatitude = ""
            state.customLocationLongitude = ""
            state.presentCustomLocationAlert = false
            return .none
            
        case .onCustomLocationAlertDoneTapped:
            state.presentCustomLocationAlert = false
            return .run { [latitude = state.customLocationLatitude, longitude = state.customLocationLongitude] send in
                do {
                    try await externalPlaceDetailHandler.handleCoordinates(latitude, longitude)
                    await send(.onCustomLocationAlertDismissed)
                } catch {
                    await send(.receivedError(error.localizedDescription))
                }
            }
            
        case .onPlaceTapped(let place):
            return .run { [latitude = "\(place.coordinates.latitude)", longitude = "\(place.coordinates.longitude)"] send in
                do {
                    try await externalPlaceDetailHandler.handleCoordinates(latitude, longitude)
                } catch {
                    await send(.receivedError(error.localizedDescription))
                }
            }
        }
    }
}

// MARK: Helpers
private extension PlacesListFeature {
    private func filter(allPlaces: [PlaceItem], searchString: String) -> [PlaceItem] {
        let toSearch = searchString.lowercased()
        return toSearch.isEmpty ? allPlaces : allPlaces.filter { $0.name.lowercased().contains(toSearch) }
    }
}

extension PlacesListFeature.State {
    static let `default`: PlacesListFeature.State = .init(isLoading: false,
                                                          searchString: "",
                                                          allPlaces: [],
                                                          filteredPlaces: [],
                                                          errorMessage: "",
                                                          presentCustomLocationAlert: false,
                                                          customLocationLatitude: "",
                                                          customLocationLongitude: "")
    
    static let mock: PlacesListFeature.State = .init(isLoading: false,
                                                     searchString: "A",
                                                     allPlaces: [.mock],
                                                     filteredPlaces: [.mock],
                                                     errorMessage: "",
                                                     presentCustomLocationAlert: false,
                                                     customLocationLatitude: "",
                                                     customLocationLongitude: "")
}

// MARK: - Convenince initializer
extension PlaceItem {
    init(index: Int, place: PlaceInfo) {
        self.init(index: index,
                  name: place.name ?? "Unknown",
                  coordinates: .init(latitude: place.latitude, longitude: place.longitude))
    }
}

//
//  PlacesListFeatureTests.swift
//  WikipediaExplorerTests
//

import ComposableArchitecture
import DependenciesAdditions
import Services
import XCTest
@testable import WikipediaExplorer

@MainActor
final class PlacesListFeatureTests: XCTestCase {
    func test_whenViewLoaded_serviceProvideData_searchPerformed_thenHasValidData() async throws {
        // Setup
        let placeInfoList = mockPlaces
        let store = buildTestStore(MockDataSource(places: placeInfoList, error: nil))
        let placeItemList = placeInfoList.enumerated().map(PlaceItem.init)
        let searchStrWithResults = "ams"
        let filteredListWithResults = placeItemList.filter { $0.name.lowercased().contains(searchStrWithResults.lowercased()) }
        let searchStrEmptyResults = "FFFFFFFF"
        let filteredListEmptyResults = [PlaceItem]()
        
        // Test
        // View loaded -> received places
        await store.send(.viewLoaded) {
            $0.isLoading = true
        }
        
        await store.receive(.receivedPlaces(placeInfoList)) {
            $0.allPlaces = placeItemList
            $0.filteredPlaces = placeItemList
            $0.isLoading = false
        }
        
        // Valid search -> list not empty
        await store.send(.searchChanged(searchStrWithResults)) {
            $0.searchString = searchStrWithResults
            $0.filteredPlaces = filteredListWithResults
        }
        
        // Invalid search -> list empty
        await store.send(.searchChanged(searchStrEmptyResults)) {
            $0.searchString = searchStrEmptyResults
            $0.filteredPlaces = filteredListEmptyResults
        }
    }
    
    func test_whenViewLoaded_andServiceThrowError_thenReceiveError() async throws {
        // Setup
        let error = NetworkServiceError.undefined
        let store = buildTestStore(MockDataSource(places: nil, error: error))
        
        // Test
        await store.send(.viewLoaded) {
            $0.isLoading = true
        }
        
        await store.receive(.receivedError(error.localizedDescription)) {
            $0.errorMessage = error.localizedDescription
            $0.isLoading = false
        }
    }
    
    func test_whenErrorAlertDismissed_thenNothingChange() async throws {
        // Setup
        let store = buildTestStore(MockDataSource(places: mockPlaces, error: nil))
        
        // Test
        await store.send(.errorAlertDismissed)
    }
    
    func test_whenCustomLocationAlertPresented_coordinateChanged_doneTapped_andPlaceHandlerDontThrow_thenStateUpdated() async throws {
        // Setup
        let latitude = "34.45"
        let longitude = "-122.00"
        var receivedLatitude: String?
        var receivedLongitude: String?
        let mockExternalDetailHandler: ExternalPlaceDetailHandler = .init { latitude, longitude in
            receivedLatitude = latitude
            receivedLongitude = longitude
        }
        let store = buildTestStore(nil, mockExternalDetailHandler)
        
        // Test - presented -> change latitude,longitude -> tap done -> external handler receive call -> dismiss
        await store.send(.onPresentCustomLocationAlertTapped) {
            $0.presentCustomLocationAlert = true
        }
        
        await store.send(.customLocationLatitudeChanged(latitude)) {
            $0.customLocationLatitude = latitude
        }
        
        await store.send(.customLocationLongitudeChanged(longitude)) {
            $0.customLocationLongitude = longitude
        }
        
        await store.send(.onCustomLocationAlertDoneTapped) {
            $0.presentCustomLocationAlert = false
        }
        
        XCTAssertEqual(receivedLatitude, latitude)
        XCTAssertEqual(receivedLongitude, longitude)
        
        await store.receive(.onCustomLocationAlertDismissed) {
            $0.customLocationLatitude = ""
            $0.customLocationLongitude = ""
            $0.presentCustomLocationAlert = false
        }
    }
    
    func test_whenCustomLocationAlertPresented_coordinateChanged_doneTapped_andPlaceHandlerThrow_thenStateUpdated() async throws {
        // Setup
        let latitude = "34.45"
        let longitude = "-122.00"
        var receivedLatitude: String?
        var receivedLongitude: String?
        let expectedError = ExternalPlaceDetailHandlerError.invalidCoordinates
        let mockExternalDetailHandler: ExternalPlaceDetailHandler = .init { latitude, longitude in
            receivedLatitude = latitude
            receivedLongitude = longitude
            throw expectedError
        }
        let store = buildTestStore(nil, mockExternalDetailHandler)
        
        // Test - presented -> change latitude,longitude -> tap done -> external handler throws -> receive error
        await store.send(.onPresentCustomLocationAlertTapped) {
            $0.presentCustomLocationAlert = true
        }
        
        await store.send(.customLocationLatitudeChanged(latitude)) {
            $0.customLocationLatitude = latitude
        }
        
        await store.send(.customLocationLongitudeChanged(longitude)) {
            $0.customLocationLongitude = longitude
        }
        
        await store.send(.onCustomLocationAlertDoneTapped) {
            $0.presentCustomLocationAlert = false
        }
        
        XCTAssertEqual(receivedLatitude, latitude)
        XCTAssertEqual(receivedLongitude, longitude)
        
        await store.receive(.receivedError(expectedError.localizedDescription)) {
            $0.errorMessage = expectedError.localizedDescription
            $0.isLoading = false
        }
    }
    
    func test_whenPlaceItemTapped_andPlaceHandlerDontThrow_thenStateUpdated() async throws {
        // Setup
        let latitude = 34.45
        let longitude = -122.00
        let place: PlaceItem = .init(index: 0,
                                     place: .init(name: "Amsterdam",
                                                  latitude: latitude,
                                                  longitude: longitude))
        var receivedLatitude: String?
        var receivedLongitude: String?
        let mockExternalDetailHandler: ExternalPlaceDetailHandler = .init { latitude, longitude in
            receivedLatitude = latitude
            receivedLongitude = longitude
        }
        let store = buildTestStore(nil, mockExternalDetailHandler)
        
        // Test - tap place item -> external handler receive call
        await store.send(.onPlaceTapped(place))
        
        XCTAssertEqual(receivedLatitude, "\(latitude)")
        XCTAssertEqual(receivedLongitude, "\(longitude)")
    }
    
    func test_whenPlaceItemTapped_andPlaceHandlerThrow_thenStateUpdated() async throws {
        // Setup
        // Setup
        let latitude = 34.45
        let longitude = -122.00
        let place: PlaceItem = .init(index: 0,
                                     place: .init(name: "Amsterdam",
                                                  latitude: latitude,
                                                  longitude: longitude))
        var receivedLatitude: String?
        var receivedLongitude: String?
        let expectedError = ExternalPlaceDetailHandlerError.invalidCoordinates
        let mockExternalDetailHandler: ExternalPlaceDetailHandler = .init { latitude, longitude in
            receivedLatitude = latitude
            receivedLongitude = longitude
            throw expectedError
        }
        let store = buildTestStore(nil, mockExternalDetailHandler)
        
        // Test - tap place item -> external handler receive call
        await store.send(.onPlaceTapped(place))
        
        XCTAssertEqual(receivedLatitude, "\(latitude)")
        XCTAssertEqual(receivedLongitude, "\(longitude)")
        
        await store.receive(.receivedError(expectedError.localizedDescription)) {
            $0.errorMessage = expectedError.localizedDescription
            $0.isLoading = false
        }
    }
}

extension PlacesListFeatureTests {
    var mockPlaces: [PlaceInfo] {
        [.init(name: "Amsterdam",
               latitude: 3.44,
               longitude: -122.22),
         .init(name: "Rotterdam",
               latitude: 1.44,
               longitude: -111.22)]
    }
    
    func buildTestStore(_ dataSource: DataSourceProtocol? = nil,
                   _ detailHandler: ExternalPlaceDetailHandler? = nil
    ) -> TestStore<PlacesListFeature.State, PlacesListFeature.Action> {
        TestStoreOf<PlacesListFeature>(initialState: PlacesListFeature.State.default) {
            PlacesListFeature()
        } withDependencies: {
            if let dataSource {
                $0.placeInfoService = PlaceInfoService(dataSource: dataSource)
            }
            if let detailHandler {
                $0.externalPlaceDetailHandler = detailHandler
            }
        }
    }
}

private struct MockDataSource: DataSourceProtocol {
    let places: [PlaceInfo]?
    let error: Error?
    
    func execute(_ endPoint: EndPoint) async throws -> Data {
        if let places {
            let response = PlaceInfoListResponse(places: places)
            return try JSONEncoder().encode(response)
        }
        throw error ?? NetworkServiceError.undefined
    }
}

//
//  PlacesListViewTests.swift
//  WikipediaExplorerTests
//

import ComposableArchitecture
import SnapshotTesting
import SwiftUI
import XCTest
@testable import WikipediaExplorer

@MainActor
final class PlacesListViewTests: XCTestCase {
    func test_view_isLoading() throws {
        verifyViewWith(state: .init(isLoading: true,
                                    searchString: "",
                                    allPlaces: [],
                                    filteredPlaces: [],
                                    errorMessage: "",
                                    presentCustomLocationAlert: false,
                                    customLocationLatitude: "",
                                    customLocationLongitude: ""))
    }
    
    func test_view_hasPlaces_andSearch() throws {
        let place: PlaceItem = .init(index: 0,
                                     place: .init(name: "Amsterdam",
                                                  latitude: 34.45,
                                                  longitude: -122.00))
        verifyViewWith(state: .init(isLoading: false,
                                    searchString: "ams",
                                    allPlaces: [place],
                                    filteredPlaces: [place],
                                    errorMessage: "",
                                    presentCustomLocationAlert: false,
                                    customLocationLatitude: "",
                                    customLocationLongitude: ""))
    }
}

private struct MockReducer: Reducer {
    typealias State = PlacesListFeature.State
    typealias Action = PlacesListFeature.Action
    
    func reduce(into state: inout PlacesListFeature.State, action: PlacesListFeature.Action) -> Effect<PlacesListFeature.Action> {
        return .none
    }
}

private extension PlacesListViewTests {
    private func verifyViewWith(state: PlacesListFeature.State,
                                named: StaticString = #function,
                                file: StaticString = #filePath,
                                line: UInt = #line
    ) {
        let store = StoreOf<MockReducer>(initialState: state) {
            MockReducer()
        }
        
        let view = PlacesListView(store: store)
        let viewController = UIHostingController(rootView: view)
        
        TestConfig.viewConfigs.forEach { config in
            assertSnapshot(of: viewController,
                           as: .image(on: config),
                           file: file,
                           testName: String(describing: named),
                           line: line)
        }
    }
}

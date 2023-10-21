//
//  ContentView.swift
//  WikipediaExplorer
//

import ComposableArchitecture
import SwiftUI

/// List view
struct PlacesListView: View {
    let store: StoreOf<PlacesListFeature>
    
    var body: some View {
        WithViewStore(self.store, observe: { $0}) { viewStore in
            NavigationView {
                // Content view
                VStack {
                    if viewStore.isLoading {
                        ProgressView()
                    } else {
                        List(viewStore.filteredPlaces) { place in
                            PlaceItemView(place: place)
                                .onTapGesture {
                                    viewStore.send(.onPlaceTapped(place))
                                }
                        }
                        .listStyle(InsetGroupedListStyle())
                        .searchable(text: viewStore.binding(
                            get: { $0.searchString },
                            send: { .searchChanged($0) }))
                    }
                }
                // Error message alert
                .alert(viewStore.errorMessage,
                       isPresented: viewStore.binding(
                        get: { !$0.errorMessage.isEmpty },
                        send: { _ in .errorAlertDismissed})
                ) {
                    Button(StringLiteral.alertConfirmation) {}
                }
                // Custom location alert
                .alert(StringLiteral.customLocationAlertTitle,
                       isPresented: viewStore.binding(
                        get: { $0.presentCustomLocationAlert },
                        send: { _ in .onCustomLocationAlertDismissed}),
                       actions: {
                        TextField(StringLiteral.customLocationLatitude, text: viewStore.binding(
                            get: { $0.customLocationLatitude },
                            send: { .customLocationLatitudeChanged($0) }
                        ))
                        TextField(StringLiteral.customLocationLongitude, text: viewStore.binding(
                            get: { $0.customLocationLongitude },
                            send: { .customLocationLongitudeChanged($0) }
                        ))
                        Button(StringLiteral.customLocationDoneButton) {
                            viewStore.send(.onCustomLocationAlertDoneTapped)
                        }
                    }
                )
                // Navigation bar config
                .navigationTitle(StringLiteral.navTitle)
                .navigationBarItems(trailing: Button(action: {
                    viewStore.send(.onPresentCustomLocationAlertTapped)
                }) {
                    Text(StringLiteral.customLocationButton)
                })
            }
            .onAppear {
                viewStore.send(.viewLoaded)
            }
        }
    }
}

// MARK: - Constants
extension PlacesListView {
    enum StringLiteral {
        static let navTitle: String = "Wikipedia Explorer"
        static let alertConfirmation: String = "Okay"
        static let customLocationButton: String = "Custom Location"
        static let customLocationAlertTitle: String = "Enter custom coordinates"
        static let customLocationLatitude: String = "Latitude"
        static let customLocationLongitude: String = "Longitude"
        static let customLocationDoneButton: String = "Open Wikipedia"
    }
}

// MARK: - Previews
struct PlacesListView_Previews: PreviewProvider {
    static var previews: some View {
        PlacesListView(store: Store(initialState: .mock) {
            PlacesListFeature()
        })
    }
}

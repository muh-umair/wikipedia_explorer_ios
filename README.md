# Wikipedia Explorer

`Wikipedia Explorer` is a sample application to fetch list of places, show them, open `Wikipedia` app on click via deeplink. To run the project open it in Xcode, select `Wikipedia Explorer` scheme and press run.

## Requirements

- XCode: 14.3.1
- Swift tool version: 5.8
- Minimum iOS Version: 16.2
- Dependency: 
    - [swift-composable-architecture](https://github.com/pointfreeco/swift-composable-architecture)
    - [swift-dependencies](https://github.com/pointfreeco/swift-dependencies)
    - [swift-snapshot-testing](https://github.com/pointfreeco/swift-snapshot-testing)
    - [swift-dependencies-additions](https://github.com/tgrapperon/swift-dependencies-additions)

## Tech-Stack

- Swift: 5
- Swift concurrency: asyn/await

## Architecture & Patterns

- Views are created with `TCA` architecture.
- `PlacesListView` is backed by a store `PlacesListFeature`.
- `PlaceItemView` is backed by a simple struct.
- Dependencies are injected with `swift-dependencies`
- There are 2 features
    - Places List: 
        - It show list of places, you can search.     
        - You can tap on an item to open details in `Wikipedia` app
    - Custom Location: 
        - It show an alert to get custom coordinates.
        - You can tap on `Open Wikipedia` to open details in `Wikipedia` app

### Tests
Following tests are added to the project
- Unit tests for business logic
- UI test for a simple success flow
- Snapshot tests for different views

# Services

`Services` is a simple library for all the network related operations. It contains required services for the main app to access data from different sources e.g. network.

## Requirements

- XCode: 14.3.1
- Swift tool version: 5.7
- Minimum iOS Version: 15.0
- Minimum MacOS Version: 10.15
- Dependency: 
    - [swift-dependencies](https://github.com/pointfreeco/swift-dependencies)
    - [swift-snapshot-testing](https://github.com/pointfreeco/swift-snapshot-testing)

## Tech-Stack

- Swift: 5
- Swift concurrency: asyn/await

## Usage

Package contain `PlaceInfoService` to perform different actions on `Place` data. `PlaceInfoService` is provided as dependency using `swift-dependency` library.

### PlaceInfoService

Get `PlaceInfoService` dependency to perform the required operation. For example to fetch list of places
```swift
@Dependency(\.placeInfoService) var service
let places = try await service.fetchList()
print(places)
```

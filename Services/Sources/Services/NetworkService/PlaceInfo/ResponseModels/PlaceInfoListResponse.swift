import Foundation

public struct PlaceInfoListResponse: Codable {
    public let places: [PlaceInfo]
    
    enum CodingKeys: String, CodingKey {
        case places = "locations"
    }
    
    public init(places: [PlaceInfo]) {
        self.places = places
    }
}

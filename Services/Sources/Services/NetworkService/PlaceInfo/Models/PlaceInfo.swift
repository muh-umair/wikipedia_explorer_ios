import Foundation

public struct PlaceInfo: Codable, Equatable {
    public var name: String?
    public let latitude: Double
    public let longitude: Double
    
    enum CodingKeys: String, CodingKey {
        case name
        case latitude = "lat"
        case longitude = "long"
    }
    
    public init(name: String?, latitude: Double, longitude: Double) {
        self.name = name
        self.latitude = latitude
        self.longitude = longitude
    }
}

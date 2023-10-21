import Foundation

/// EndPoint for place requests
enum PlaceInfoEndPoint {
    case fetchList
}

extension PlaceInfoEndPoint: EndPoint {
    var path: String {
        switch self {
        case .fetchList:
            return "/abnamrocoesd/assignment-ios/main/locations.json"
        }
    }
    
    var method: RequestMethod {
        switch self {
        case .fetchList:
            return .get
        }
    }
    
    var headers: ReaquestHeaders? {
        switch self {
        case .fetchList:
            return nil
        }
    }
    
    var parameters: RequestParameters? {
        switch self {
        case .fetchList:
            return nil
        }
    }
    
    var body: Encodable? {
        switch self {
        case .fetchList:
            return nil
        }
    }
    
    var mockFileName: String? {
        switch self {
        case .fetchList:
            return "places_list"
        }
    }
    
}


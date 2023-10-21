import Foundation

/// Request headers
public typealias ReaquestHeaders = [String: String]

/// Request headers
public typealias RequestParameters = [String : Any]

/// Request methods
public enum RequestMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
}

/// Protocol defining a structure for different requests that can be made on ``NetworkService``
public protocol EndPoint {
    /// Relative API path
    var path: String { get }
    
    /// Request method (e.g. get, post, put, etc.)
    var method: RequestMethod { get }
    
    /// Request headers (e.g. auth token, etc.)
    var headers: ReaquestHeaders? { get }
    
    /// Request parameters (can be used with different types e.g. get, post, etc.)
    var parameters: RequestParameters? { get }
    
    /// Raw body of request
    var body: Encodable? { get }
    
    /// Mock file used for local datasource
    var mockFileName: String? { get }
}

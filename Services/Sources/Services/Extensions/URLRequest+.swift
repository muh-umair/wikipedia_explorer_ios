import Foundation

extension URLRequest {
    /// Build ``URLRequest`` from ``EndPoint`` and ``APIBaseURL``
    ///
    /// - parameter from: ``EndPoint`` used to build the request
    /// - parameter baseURL: ``APIBaseURL`` base url used for request
    /// - returns: ``URLRequest`` if building is successful
    static func build(from endPoint: EndPoint, baseURL: APIBaseURL) -> URLRequest? {
        let queryItems = endPoint.parameters?.map { (key: String, value: Any) -> URLQueryItem in
            URLQueryItem(name: key, value: String(describing: value))
        }
        
        guard var urlComponents = URLComponents(string: baseURL.rawValue) else {
            return nil
        }
        urlComponents.path = urlComponents.path + endPoint.path
        urlComponents.queryItems = queryItems
        
        guard let url = urlComponents.url else {
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = endPoint.method.rawValue
        request.allHTTPHeaderFields = endPoint.headers
        request.httpBody = endPoint.body?.jsonData
        
        return request
    }
}

import Foundation

extension URLSessionConfiguration {
    /// Build ``URLSessionConfiguration`` with params
    static func build(with timeout: TimeInterval) -> URLSessionConfiguration{
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = timeout
        configuration.timeoutIntervalForResource = timeout
        return configuration
    }
}

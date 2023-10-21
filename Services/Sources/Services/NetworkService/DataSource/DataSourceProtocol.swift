import Foundation

/// Protocol defining datasource
public protocol DataSourceProtocol {
    /// Execute an ``EndPoint`` and return ``Data`` or throw an ``Error``
    /// - parameter endPoint: ``EndPoint`` to execute
    /// - returns: fetched ``Data`` or throw an error
    func execute(_ endPoint: EndPoint) async throws -> Data
}

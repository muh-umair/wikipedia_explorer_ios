import Foundation

/// Local datasource to fetch data from mock files
struct LocalDataSource: DataSourceProtocol {
    /// Execute ``EndPoint`` and return data. Use `mockFileName` from `endPoint`.
    func execute(_ endPoint: EndPoint) async throws -> Data {
        guard let fileName = endPoint.mockFileName else {
            throw NetworkServiceError.noMockFound
        }
        guard let data = try Data(contentOfFile: fileName) else {
            throw NetworkServiceError.failedMockLoading
        }
        return data
    }
}

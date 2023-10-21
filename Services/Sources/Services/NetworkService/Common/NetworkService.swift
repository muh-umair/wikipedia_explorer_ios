import Foundation

/// Network service to execute different end points
public class NetworkService {
    // Properties
    private let dataSource: DataSourceProtocol
    private let decoder: JSONDecoder
    
    // Init
    public init(dataSource: DataSourceProtocol) {
        self.dataSource = dataSource
        self.decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
    }
    
    /// Generic method to execute endPoint and return decoded result or throw error
    /// - parameter endPoint: ``EndPoint`` object to execute
    /// - returns: Decoded result to proper type or throws and error
    func execute<T: Decodable>(_ endPoint: EndPoint) async throws -> T {
        do {
            let data = try await dataSource.execute(endPoint)
            return try decode(with: data)
        } catch let error as NetworkServiceError {
            throw error
        } catch {
            throw NetworkServiceError(error: error)
        }
    }
    
    // Decode data to proper type
    private func decode<T: Decodable>(with data: Data) throws -> T {
        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            throw NetworkServiceError.failedDecoding
        }
    }
}

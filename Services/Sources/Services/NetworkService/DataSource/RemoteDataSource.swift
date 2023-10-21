import Dependencies
import Foundation

/// Structure for config
struct RemoteDataSourceConfig {
    let baseURL: APIBaseURL
    let timeout: TimeInterval
}

/// Dependencies options for ``RemoteDataSourceConfig``
extension RemoteDataSourceConfig: DependencyKey {
    static var liveValue: RemoteDataSourceConfig {
        RemoteDataSourceConfig(baseURL: .dev, timeout: 30)
    }
    
    static var testValue: RemoteDataSourceConfig {
        RemoteDataSourceConfig(baseURL: .dev, timeout: 30)
    }
}

/// Dependency value for ``RemoteDataSourceConfig``
extension DependencyValues {
    var dataSourceConfig: RemoteDataSourceConfig {
        get { self[RemoteDataSourceConfig.self] }
        set { self[RemoteDataSourceConfig.self] = newValue }
    }
}

/// Remote datasource to fetch data from network
struct RemoteDataSource: DataSourceProtocol {
    // Dependencies
    @Dependency(\.dataSourceConfig) private var config
    
    /// Execute ``EndPoint`` and return ``Data`` using actual network and network props from `endPoint`
    func execute(_ endPoint: EndPoint) async throws -> Data {
        guard let urlRequest = URLRequest.build(from: endPoint, baseURL: config.baseURL) else {
            throw NetworkServiceError.invalidRequest
        }
        let urlSession = URLSession(configuration: .build(with: config.timeout))
        let (data, response) = try await urlSession.data(for: urlRequest)
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw NetworkServiceError.invalidResponse
        }
        return data
    }
}

import Dependencies
import Foundation

/// Place info service to perform different requests
final public class PlaceInfoService: NetworkService {
    /// Fetch list of places. Can throw different errors.
    /// - returns: List of ``PlaceInfo``
    public func fetchList() async throws -> [PlaceInfo] {
        let response: PlaceInfoListResponse = try await execute(PlaceInfoEndPoint.fetchList)
        return response.places
    }
}

/// Dependencies options for ``PlaceInfoService``
extension PlaceInfoService: DependencyKey {
    // Use remote services for live app
    public static var liveValue: PlaceInfoService {
        PlaceInfoService(dataSource: RemoteDataSource())
    }
    
    // Use local files for tests
    public static var testValue: PlaceInfoService {
        PlaceInfoService(dataSource: LocalDataSource())
    }
    
    // Use local files for previews
    public static var previewValue: PlaceInfoService {
        PlaceInfoService(dataSource: LocalDataSource())
    }
}

/// Dependency value for ``PlaceInfoService``. This will be used by the host app.
extension DependencyValues {
    public var placeInfoService: PlaceInfoService {
        get { self[PlaceInfoService.self] }
        set { self[PlaceInfoService.self] = newValue }
    }
}

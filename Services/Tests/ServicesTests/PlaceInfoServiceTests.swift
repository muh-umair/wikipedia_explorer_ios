import InlineSnapshotTesting
import XCTest
@testable import Services

final class PlaceInfoServiceTests: XCTestCase {
    private var sut: PlaceInfoService!
    
    override func setUpWithError() throws {
        sut = PlaceInfoService(dataSource: LocalDataSource())
    }
    
    override func tearDownWithError() throws {
        sut = nil
    }
}

extension PlaceInfoServiceTests {
    
    func test_fetchList() async throws {
        let places = try await sut.fetchList()
        assertInlineSnapshot(of: places, as: .json) {
            """
            [
              {
                "lat" : 52.3547498,
                "long" : 4.8339214999999998,
                "name" : "Amsterdam"
              },
              {
                "lat" : 19.082399800000001,
                "long" : 72.811146800000003,
                "name" : "Mumbai"
              },
              {
                "lat" : 55.6713442,
                "long" : 12.523785,
                "name" : "Copenhagen"
              },
              {
                "lat" : 40.438063800000002,
                "long" : -3.7495758000000001
              }
            ]
            """
        }
    }
    
}

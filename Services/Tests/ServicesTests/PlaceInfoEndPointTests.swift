import InlineSnapshotTesting
import XCTest
@testable import Services

final class PlaceInfoEndPointTests: XCTestCase {
    
    private var sut: PlaceInfoEndPoint!
    
    override func tearDownWithError() throws {
        sut = nil
    }
}

extension PlaceInfoEndPointTests {
    
    func test_listEndpoint_initializedCorrectly()  {
        sut = .fetchList
        
        XCTAssertEqual(sut.path, "/abnamrocoesd/assignment-ios/main/locations.json")
        XCTAssertEqual(sut.method, .get)
        XCTAssertNil(sut.headers)
        XCTAssertNil(sut.parameters)
        XCTAssertNil(sut.body)
        XCTAssertEqual(sut.mockFileName, "places_list")
    }
    
}

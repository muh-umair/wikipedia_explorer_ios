//
//  WikipediaExplorerUITests.swift
//  WikipediaExplorerUITests
//

import XCTest

final class WikipediaExplorerUITests: XCTestCase {

    private var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    func testOpenDetail() throws {
        // Test - received data -> cell exist -> search -> tap on cell
        var itemView = app.otherElements["PlaceItem"].firstMatch
        XCTAssertTrue(itemView.waitForExistence(timeout: 1.0))
        XCTAssertTrue(itemView.isHittable)
        
        var itemsCount = app.otherElements.allElementsBoundByIndex.filter { $0.identifier == "PlaceItem" }.count
        XCTAssertEqual(itemsCount, 4)

        let searchField = app.searchFields["Search"].firstMatch
        XCTAssertTrue(searchField.waitForExistence(timeout: 1.0))
        searchField.tap()
        searchField.typeText("ams")
        
        itemsCount = app.otherElements.allElementsBoundByIndex.filter { $0.identifier == "PlaceItem" }.count
        XCTAssertEqual(itemsCount, 1)
        
        itemView = app.otherElements["PlaceItem"].firstMatch
        itemView.tap()
    }
}

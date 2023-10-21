//
//  WikipediaPlaceDetailHandlerTests.swift
//  WikipediaExplorerTests
//

import ComposableArchitecture
import DependenciesAdditions
import Services
import XCTest
@testable import WikipediaExplorer

@MainActor
final class WikipediaPlaceDetailHandlerTests: XCTestCase {
    func test_whenHandleCalledWithValidCoordinates_andCanOpenNextApp_thenOpenCalledWithValidURL() async throws {
        // Setup
        let latitude = "34.45"
        let longitude = "-122.56"
        let expectedURL = "wikipedia://places?WMFCoordinates=\(latitude),\(longitude)"
        var canOpenCalledWithURL: String?
        var openCalledWithURL: String?
        
        // Test
        try await withDependencies {
            // Override dependencies
            $0.application.$canOpenURL = { @Sendable url in
                canOpenCalledWithURL = url.absoluteString
                return true
            }
            $0.application.$open = { @Sendable url, _ in
                openCalledWithURL = url.absoluteString
                return true
            }
        } operation: {
            let sut = ExternalPlaceDetailHandler.wikipedia
            try await sut.handleCoordinates(latitude, longitude)
            XCTAssertEqual(expectedURL, canOpenCalledWithURL)
            XCTAssertEqual(expectedURL, openCalledWithURL)
        }
    }
    
    func test_whenHandleCalledWithValidCoordinates_andCantOpenNextApp_thenErrorThrown() async throws {
        // Setup
        let latitude = "34.45"
        let longitude = "-122.56"
        let expectedURL = "wikipedia://places?WMFCoordinates=\(latitude),\(longitude)"
        let expectedError = ExternalPlaceDetailHandlerError.cantOpenExternalApp("Wikipedia")
        var canOpenCalledWithURL: String?
        
        // Test
        try await withDependencies {
            // Override dependencies, overrriding open not needed because error should be thrown before that
            $0.application.$canOpenURL = { @Sendable url in
                canOpenCalledWithURL = url.absoluteString
                return false
            }
        } operation: {
            let sut = ExternalPlaceDetailHandler.wikipedia
            try await XCTAssertThrowsAsyncError(try await sut.handleCoordinates(latitude, longitude)) { error in
                XCTAssertEqual(expectedURL, canOpenCalledWithURL)
                let receivedError = try XCTUnwrap(error as? ExternalPlaceDetailHandlerError)
                XCTAssertEqual(expectedError, receivedError)
                XCTAssertEqual(receivedError.localizedDescription, "Can't open Wikipedia")
            }
        }
    }
    
    func test_whenHandleCalledWithInvalidCoordinates_thenErrorThrown() async throws {
        // Setup
        let latitude = "AbC"
        let longitude = ""
        let expectedError = ExternalPlaceDetailHandlerError.invalidCoordinates
        
        // No override dependencies needed becuase error should be thrown before that
        // Test
        let sut = ExternalPlaceDetailHandler.wikipedia
        try await XCTAssertThrowsAsyncError(try await sut.handleCoordinates(latitude, longitude)) { error in
            let receivedError = try XCTUnwrap(error as? ExternalPlaceDetailHandlerError)
            XCTAssertEqual(expectedError, receivedError)
            XCTAssertEqual(receivedError.localizedDescription, "Invalid latitude/longitude")
        }
    }
    
}

extension XCTest {
    func XCTAssertThrowsAsyncError<T>(_ expression: @autoclosure () async throws -> T,
                                      _ message: @autoclosure () -> String = "",
                                      file: StaticString = #filePath,
                                      line: UInt = #line,
                                      _ errorHandler: (_ error: Error) throws -> Void = { _ in }
    ) async throws {
        do {
            _ = try await expression()
            let customMessage = message()
            if customMessage.isEmpty {
                XCTFail("Asynchronous call did not throw an error.", file: file, line: line)
            } else {
                XCTFail(customMessage, file: file, line: line)
            }
        } catch {
            try errorHandler(error)
        }
    }
}

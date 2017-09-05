import Foundation
import XCTest
@testable import SwiftRecord


extension Migrator {
	func create() {
		let createExpectation = XCTestExpectation(description: "create")
		self.create { (error) in
			XCTAssertNil(error)
			createExpectation.fulfill()
		}
		let result = XCTWaiter.wait(for: [createExpectation], timeout: 5)
		XCTAssertEqual(result, .completed)
	}
	
	func drop() {
		let dropExpectation = XCTestExpectation(description: "drop")
		self.drop { (error) in
			XCTAssertNil(error)
			dropExpectation.fulfill()
		}
		let result = XCTWaiter.wait(for: [dropExpectation], timeout: 5)
		XCTAssertEqual(result, .completed)
	}
	
	func migrate() {
		let migrateExpectation = XCTestExpectation(description: "migrate")
		self.migrate { (error) in
			XCTAssertNil(error)
			migrateExpectation.fulfill()
		}
		let result = XCTWaiter.wait(for: [migrateExpectation], timeout: 5)
		XCTAssertEqual(result, .completed)
	}
}

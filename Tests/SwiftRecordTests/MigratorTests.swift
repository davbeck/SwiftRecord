import XCTest
@testable import SwiftRecord
import PG
@testable import SwiftRecordPostgres


class SwiftRecordTests: XCTestCase {
    func testExample() {
		var config = Config.shared
		config.database = "SwiftRecordTests"
        sharedAdapter = PGAdapter(config)
        let migrator = Migrator([
			Migration(name: "create_example", up: { connection, completion in
				completion(nil)
			})
        ])
        
        XCTAssertEqual(migrator.migrations.count, 1)
		
		let createExpectation = expectation(description: "create")
		migrator.create { (error) in
			XCTAssertNil(error)
			createExpectation.fulfill()
		}
		self.wait(for: [createExpectation], timeout: 5)
		
		
		let dropExpectation = expectation(description: "drop")
		migrator.drop { (error) in
			XCTAssertNil(error)
			dropExpectation.fulfill()
		}
		self.wait(for: [dropExpectation], timeout: 5)
    }


    static var allTests = [
        ("testExample", testExample),
    ]
}

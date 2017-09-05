import XCTest
@testable import SwiftRecord
import PG
@testable import SwiftRecordPostgres


class SwiftRecordTests: XCTestCase {
	let config: Config = {
		var config = Config.shared
		config.database = "SwiftRecordTests_\(UUID().uuidString.prefix(5))"
		return config
	}()
	
    func testExample() {
        sharedAdapter = PGAdapter(config)
        let migrator = Migrator([
			Migration(name: "create_example", up: { connection, completion in
				connection.createTable("example", [
					Column("title", .text)
				], completion: completion)
			})
        ])
        XCTAssertEqual(migrator.migrations.count, 1)
		
		
		migrator.create()
		
		for _ in 0..<2 {
			// duplicate migrations should succeed without change
			migrator.migrate()
		}
		
		
		let migrator2 = Migrator(migrator.migrations + [
			Migration(name: "create_example2", up: { connection, completion in
				connection.createTable("example2", [
					Column("title", .text)
				], completion: completion)
			})
		])
		migrator2.migrate()
		
		
		migrator.drop()
    }


    static var allTests = [
        ("testExample", testExample),
    ]
}

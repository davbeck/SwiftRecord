import Foundation
import AsyncKit


public var sharedAdapter: Adapter!


public protocol Adapter {
	func createConnection(completion: @escaping (Result<Connection>) -> Void)
	
	func createDatabase(completion: @escaping (Swift.Error?) -> Void)
	
	func dropDatabase(completion: @escaping (Swift.Error?) -> Void)
}

public protocol Connection: class {
	func connect(completion: ((Swift.Error?) -> Void)?)
	
	func createMigrationsTable(completion: @escaping (Swift.Error?) -> Void)
	
	func beginMigration(_ migration: Migration, completion: @escaping (Result<Bool>) -> Void)
	func finalizeMigration(_ migration: Migration, completion: @escaping (Swift.Error?) -> Void)
}

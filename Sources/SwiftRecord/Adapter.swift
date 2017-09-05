import Foundation
import AsyncKit


public var sharedAdapter: Adapter!


public protocol Adapter {
	func createConnection(completion: @escaping (Result<Connection>) -> Void)
	
	func createDatabase(completion: @escaping (Swift.Error?) -> Void)
	
	func dropDatabase(completion: @escaping (Swift.Error?) -> Void)
	
	static func sanitizeIdentifier(_ text: String) -> String
	
	static func definition(for column: Column) -> String
	static func definition(for columns: [Column]) -> String
}

extension Adapter {
	public static func sanitizeIdentifier(_ text: String) -> String {
		return text.filter({ $0 != "\"" })
			.components(separatedBy: .whitespacesAndNewlines).joined(separator: "_")
			.lowercased()
	}
	
	
	public static func definition(for column: Column) -> String {
		return """
			"\(column.name)" \(column.type.rawValue)
		"""
	}
	
	public static func definition(for columns: [Column]) -> String {
		return columns
			.map({ self.definition(for: $0) })
			.joined(separator: ", \n")
	}
}

public protocol Connection: class {
	func createMigrationsTable(completion: @escaping (Swift.Error?) -> Void)
	
	func beginMigration(_ migration: Migration, completion: @escaping (Result<Bool>) -> Void)
	func finalizeMigration(_ migration: Migration, completion: @escaping (Swift.Error?) -> Void)
	
	func createTable(_ name: String, _ columns: [Column], completion: @escaping (Swift.Error?) -> Void)
	
	func disconnect()
}

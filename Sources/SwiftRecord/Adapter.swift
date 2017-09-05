import Foundation
import AsyncKit


public var sharedAdapter: Adapter!


public protocol Adapter {
	func createConnection(completion: @escaping (Result<Connection>) -> Void)
	
	func createDatabase(completion: @escaping (Swift.Error?) -> Void)
	
	func dropDatabase(completion: @escaping (Swift.Error?) -> Void)
}

extension Adapter {
	
}

public protocol Connection: class {
	static func sanitizeIdentifier(_ text: String) -> String
	
	static func definition(for column: Column) -> String
	static func definition(for columns: [Column]) -> String
	
	
	func createMigrationsTable(completion: @escaping (Swift.Error?) -> Void)
	
	func beginMigration(_ migration: Migration, completion: @escaping (Result<Bool>) -> Void)
	func finalizeMigration(_ migration: Migration, completion: @escaping (Swift.Error?) -> Void)
	
	func performQuerey(_ query: String, completion: @escaping (Result<SwiftRecord.QueryResult>) -> Void)
	func performQuerey(_ query: String, bindings: [Any?], completion: @escaping (Result<SwiftRecord.QueryResult>) -> Void)
	
	func createTable(_ name: String, _ columns: [Column], completion: @escaping (Swift.Error?) -> Void)
	func createTable(_ name: String, primaryKey: Column?, _ columns: [Column], completion: @escaping (Swift.Error?) -> Void)
	
	func dropTable(_ name: String, completion: @escaping (Swift.Error?) -> Void)
	
	func disconnect()
}

extension Connection {
	public static func sanitizeIdentifier(_ text: String) -> String {
		return text.filter({ $0 != "\"" })
			.components(separatedBy: .whitespacesAndNewlines).joined(separator: "_")
			.lowercased()
	}
	
	public static func definition(for column: Column) -> String {
		var parts: [String] = []
		parts.append("\"\(column.name)\"")
		parts.append(column.type.rawValue)
		if !column.isNullable {
			parts.append("NOT NULL")
		}
		return "\t" + parts.joined(separator: " ")
	}
	
	public static func definition(for columns: [Column]) -> String {
		return columns
			.map({ self.definition(for: $0) })
			.joined(separator: ", \n")
	}
	
	
	public func performQuerey(_ query: String, completion: @escaping (Result<SwiftRecord.QueryResult>) -> Void) {
		self.performQuerey(query, bindings: [], completion: completion)
	}
	
	public func createTable(_ name: String, _ columns: [Column], completion: @escaping (Swift.Error?) -> Void) {
		self.createTable(name, primaryKey: .defaultPrimaryKey, columns, completion: completion)
	}
	
	public func createTable(_ name: String, primaryKey: Column?, _ columns: [Column], completion: @escaping (Swift.Error?) -> Void) {
		let columnDefinitions: String
		if let primaryKey = primaryKey {
			var allColumns = columns
			allColumns.insert(primaryKey, at: 0)
			
			columnDefinitions = """
			\(Self.definition(for: allColumns)),
			\tPRIMARY KEY(\(primaryKey.name))
			"""
		} else {
			columnDefinitions = Self.definition(for: columns)
		}
		
		
		let query = """
		CREATE TABLE "\(Self.sanitizeIdentifier(name))" (
		\(columnDefinitions)
		);
		"""
		print("create table using: \(query)")
		
		self.performQuerey(query) { (result) in
			completion(result.error)
		}
	}
	
	public func dropTable(_ name: String, completion: @escaping (Swift.Error?) -> Void) {
		let query = """
		DROP TABLE "\(Self.sanitizeIdentifier(name))"
		"""
		self.performQuerey(query) { (result) in
			completion(result.error)
		}
	}
}

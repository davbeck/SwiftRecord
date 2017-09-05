import Foundation
import SwiftRecord
import PG
import AsyncKit


extension PG.Client.Config {
	public init(_ config: SwiftRecord.Config) {
		if let url = config.url {
			try! self.init(url: url)
		} else {
			self.init(
				host: config.host,
				user: config.user ?? "postgres",
				password: config.password,
				database: config.database,
				port: config.port ?? PG.Client.Config.defaultPort
			)
		}
	}
}


public struct PGAdapter: Adapter {
	let config: SwiftRecord.Config
	
	init(_ config: SwiftRecord.Config) {
		self.config = config
	}
	
	public func createConnection(completion: @escaping (Result<SwiftRecord.Connection>) -> Void) {
		let config = PG.Client.Config(self.config)
		let client = Client(config)
		
		client.connect { (error) in
			if let error = error {
				return completion(.failure(error))
			} else {
				completion(.success(client))
			}
		}
	}
	
	public func createDatabase(completion: @escaping (Swift.Error?) -> Void) {
		let config = PG.Client.Config(self.config)
		PG.Client.createDatabase(using: config, completion: completion)
	}
	
	public func dropDatabase(completion: @escaping (Swift.Error?) -> Void) {
		let config = PG.Client.Config(self.config)
		PG.Client.dropDatabase(using: config, completion: completion)
	}
}


extension PG.Client: SwiftRecord.Connection {
    public func createMigrationsTable(completion: @escaping (Swift.Error?) -> Void) {
        self.exec("CREATE TABLE IF NOT EXISTS migrations name TEXT PRIMARY KEY;") { (result) in
            completion(result.error)
        }
    }
    
    public func beginMigration(_ migration: Migration, completion: @escaping (Result<Bool>) -> Void) {
        self.exec(Query("SELECT name FROM migrations WHERE name = ?;", migration.name)) { (result) in
            switch result {
            case .success(let value):
                completion(.success(value.rowCount > 0))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    public func finalizeMigration(_ migration: Migration, completion: @escaping (Swift.Error?) -> Void) {
        self.exec(Query("INSERT INTO migrations (name) VALUES (?);", migration.name)) { (result) in
            switch result {
            case .success(_):
                completion(nil)
            case .failure(let error):
                completion(error)
            }
        }
    }
}

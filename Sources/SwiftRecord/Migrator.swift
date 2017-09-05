import Foundation


public class Migrator {
    public enum Error: Swift.Error {
        case duplicateMigrationName
    }
    
    public let adapter: Adapter
    public let migrations: [Migration]
    
    public init(adapter: Adapter = sharedAdapter, _ migrations: [Migration]) {
        self.adapter = adapter
        self.migrations = migrations
    }
    
    public func validateMigrations() throws {
        var names: Set<String> = []
        for migration in migrations {
            guard !names.contains(migration.name) else { throw Error.duplicateMigrationName }
            names.insert(migration.name)
        }
    }
	
	public func create(completion: @escaping (Swift.Error?) -> Void) {
		adapter.createDatabase(completion: completion)
	}
    
    public func drop(completion: @escaping (Swift.Error?) -> Void) {
        adapter.dropDatabase(completion: completion)
    }
    
    public func migrate(completion: @escaping (Swift.Error?) -> Void) {
		do {
			try validateMigrations()
		} catch {
			return completion(error)
		}
		
		adapter.createConnection { (result) in
			guard let connection = result.value else { return completion(result.error) }
			
			connection.createMigrationsTable { (error) in
				guard error == nil else { return completion(error) }
				
				self.run(self.migrations, on: connection, completion: { (error) in
					completion(error)
				})
			}
		}
    }
    
	private func run(_ migrations: [Migration], on connection: Connection, completion: @escaping (Swift.Error?) -> Void) {
        guard let migration = migrations.first else {
            return completion(nil)
        }
        
        migration.migrate(connection) { (result) in
            guard result.error == nil else { return completion(result.error) }
            
            self.run(Array(migrations.dropFirst()), on: connection, completion: completion)
        }
    }
    
    
    public func runCLI(arguments: [String] = CommandLine.arguments) {
		guard let command = arguments.first else { return }
		
		switch command {
		case "create":
			print("creating db...")
			self.create(completion: { (error) in
				if let error = error {
					print("error creating db: \(error)")
					exit(-1)
				}
				exit(0)
			})
		case "drop":
			print("dropping db...")
			self.drop(completion: { (error) in
				if let error = error {
					print("error dropping db: \(error)")
					exit(-1)
				}
				exit(0)
			})
		case "migrate":
			print("running all migrations db...")
			self.migrate(completion: { (error) in
				if let error = error {
					print("error dropping db: \(error)")
					exit(-1)
				}
				exit(0)
			})
		default:
			print("error: unrecognized command '\(command)'")
			exit(-1)
		}
		
		dispatchMain()
    }
}

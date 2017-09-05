import Foundation
import AsyncKit


public class Migration {
	public typealias Work = (Connection, @escaping (Error?) -> Void) -> Void
	
    public let name: String
	public let up: Work
	public let down: Work?
    
    public init(name: String, up: @escaping Work, down: Work? = nil) {
        self.name = name
        self.up = up
		self.down = down
    }
    
    
    public func migrate(_ adapter: Connection, completion: @escaping (Result<Bool>) -> Void) {
        adapter.beginMigration(self) { (result) in
            guard let value = result.value else { return completion(result) }
            guard !value else { return completion(.success(false)) }
            
			self.up(adapter) { error in
				if let error = error { return completion(.failure(error)) }
				
				adapter.finalizeMigration(self, completion: { (error) in
					if let error = error {
						completion(.failure(error))
					} else {
						completion(.success(true))
					}
				})
			}
        }
    }
    
    public func revert(_ adapter: Connection) {
        
    }
}

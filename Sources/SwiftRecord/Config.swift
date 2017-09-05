import Foundation


public let ENV = ProcessInfo.processInfo.environment


public struct Config {
	public static var shared: Config {
		if let urlString = ENV["DATABASE_URL"] ?? ENV["DB_URL"], let url = URL(string: urlString) {
			return Config(url)
		}
		
		return Config(
			host: ENV["DATABASE_HOST"] ?? ENV["DB_HOST"] ?? "localhost",
			user: ENV["DATABASE_USER"] ?? ENV["DB_USER"],
			password: ENV["DATABASE_PASSWORD"] ?? ENV["DATABASE_PASS"] ?? ENV["DB_PASSWORD"] ?? ENV["DB_PASS"],
			database: ENV["DATABASE_NAME"] ?? ENV["DB_NAME"],
			port: (ENV["DATABASE_PORT"] ?? ENV["DB_PORT"]).flatMap({ Int($0) })
		)
	}
	
	init(_ url: URL) {
		self.url = url
		
		self.host = url.host ?? "localhost"
		self.user = url.user
		self.password = url.password
		self.database = url.path
		self.port = url.port
	}
	
	init(host: String = "localhost", user: String?, password: String?, database: String?, port: Int?) {
		self.url = nil
		
		self.host = host
		self.user = user
		self.password = password
		self.database = database
		self.port = port
	}
	
	
    public var url: URL?
    
    public var host: String
    
    public var user: String?
    
    public var password: String?
    
    public var database: String?
    
    public var port: Int?
}

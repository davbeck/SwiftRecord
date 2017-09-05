import Foundation


public struct Column {
	public static let defaultPrimaryKey = Column("id", .integer)
	
	
    public let name: String
    
    public struct DataType: RawRepresentable {
        public let rawValue: String
        
        public init(rawValue: String) {
            self.rawValue = rawValue
        }
		
		public static let integer = Column.DataType(rawValue: "int")
		public static let text = Column.DataType(rawValue: "text")
		public static let boolean = Column.DataType(rawValue: "boolean")
    }
    public let type: DataType
	
	public let isNullable: Bool
	
	
	public init(_ name: String, _ type: DataType, isNullable: Bool = true) {
		self.name = name
		self.type = type
		self.isNullable = isNullable
	}
}

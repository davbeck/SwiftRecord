import Foundation
import SwiftRecord


extension Column.DataType {
    public static let smallint = Column.DataType(rawValue: "smallint")
    public static let bigint = Column.DataType(rawValue: "bigint")
    
    public static let float = Column.DataType(rawValue: "float8")
    
    public static func varchar(_ length: Int) -> Column.DataType {
        return Column.DataType(rawValue: "varchar(\(length)")
    }
    
    
    public static let uuid = Column.DataType(rawValue: "uuid")
}

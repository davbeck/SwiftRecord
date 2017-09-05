import Foundation


public struct Column {
    public let name: String
    
    public struct DataType: RawRepresentable {
        public let rawValue: String
        
        public init(rawValue: String) {
            self.rawValue = rawValue
        }
    }
    public let type: DataType
}

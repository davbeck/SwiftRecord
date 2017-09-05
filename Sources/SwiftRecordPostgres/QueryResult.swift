import Foundation
import SwiftRecord
import PG


extension PG.QueryResult: SwiftRecord.QueryResult {
	public var resultFields: [SwiftRecord.Field] {
		return self.fields.map({ $0 as SwiftRecord.Field })
	}
	
	public var resultRows: [SwiftRecord.Row] {
		return self.rows.map({ $0 as SwiftRecord.Row })
	}
}

extension PG.QueryResult.Row: SwiftRecord.Row {
	
}

extension PG.Field: SwiftRecord.Field {
	
}

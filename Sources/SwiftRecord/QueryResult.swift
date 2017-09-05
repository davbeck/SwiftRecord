import Foundation


public protocol QueryResult {
	/// Information for each field in each row
	var resultFields: [Field] { get }
	
	/// If the query was a SELECT query, contains the rows returned, or an empty array for other types of queries.
	var resultRows: [Row] { get }
	
	/// The number of rows effected by the query. For SELECT, this should be the same as `rows.count`, but for other types will be the number of rows updated, inserted or deleted.
	var rowCount: Int { get }
}


public protocol Row {
	subscript(index: Int) -> Any? { get }
	subscript(name: String) -> Any? { get }
}


public protocol Field {
	/// The name of the column or generated field
	var name: String { get }
}

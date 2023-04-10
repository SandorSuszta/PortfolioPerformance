import Foundation

extension Array where Element == SearchResult {
    
    /// Sorts the array of `SearchResult` instances by symbol prefix. The results whose symbol
    /// start with the query string come first in the array
    ///
    /// - Parameter query: The query string to sort by.
    /// - Returns: A new array of `SearchResult` instances sorted by symbol prefix.
   
    func sortedByPrefix(_ query: String) -> [SearchResult] {
        let lowercasedQuery = query.lowercased()
        
        let comparator: (SearchResult, SearchResult) -> Bool = { (result1, result2) -> Bool in
            let isPrefix1 = result1.symbol.lowercased().hasPrefix(lowercasedQuery)
            let isPrefix2 = result2.symbol.lowercased().hasPrefix(lowercasedQuery)
            
            return isPrefix1 && !isPrefix2 ? true
            : !isPrefix1 && isPrefix2 ? false
            : result1.symbol < result2.symbol
        }
        
        return self.sorted(by: comparator)
    }
}


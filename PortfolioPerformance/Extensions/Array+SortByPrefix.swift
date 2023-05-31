import Foundation

extension Array where Element == SearchResult {
    
    /// Sorts the array of `SearchResult` instances by symbol prefix. The results whose name or symbol
    /// start with the query string come first in the array
    ///
    /// - Parameter query: The query string to sort by.
    /// - Returns: A new array of `SearchResult` instances sorted by name and symbol prefix.
   
    func sortedByPrefix(_ query: String) -> [SearchResult] {
        let lowercasedQuery = query.lowercased()
        
        let comparator: (Element, Element) -> Bool = { (element1, element2) -> Bool in
            let isPrefix1 = element1.name.lowercased().hasPrefix(lowercasedQuery)
                || element1.symbol.lowercased().hasPrefix(lowercasedQuery)
            
            let isPrefix2 = element2.name.lowercased().hasPrefix(lowercasedQuery)
                || element2.symbol.lowercased().hasPrefix(lowercasedQuery)
            
            return isPrefix1 && !isPrefix2 ? true
            : !isPrefix1 && isPrefix2 ? false
            : element1.name < element2.name
        }
        
        return self.sorted(by: comparator)
    }
}

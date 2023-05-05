//
//  Array+sortByHasPrefix.swift
//  PortfolioPerformance
//
//  Created by Nataliia Shusta on 09/04/2023.
//

import Foundation

extension Array where Element == SearchResult {
    func sortedByPrefix(_ query: String) -> [SearchResult] {
        let comparator: (SearchResult, SearchResult) -> Bool = { (result1, result2) -> Bool in
            let lowercasedQuery = query.lowercased()
            let isPrefix1 = result1.symbol.lowercased().hasPrefix(lowercasedQuery)
            let isPrefix2 = result2.symbol.lowercased().hasPrefix(lowercasedQuery)
            
            return isPrefix1 && !isPrefix2 ? true
                : !isPrefix1 && isPrefix2 ? false
                : result1.symbol < result2.symbol
        }
        
        return self.sorted(by: comparator)
    }
}


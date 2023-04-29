import Foundation

extension Array where Element: Identifiable, Element.ID == String {
    
    /// Sorts the array based on a list of IDs.
    ///
    /// - Parameters:
    ///   - list: A list of IDs that defines the sort order.
    ///
    /// - Returns: A new array of elements sorted based on the order of IDs in the list.
    ///
    func sorted(byList list: [String]) -> [Element] {
        let comparator: (Element, Element) -> Bool = { (element1, element2) in
            
            guard let index1 = list.firstIndex(of: element1.id),
                  let index2 = list.firstIndex(of: element2.id)
            else { return false }
            
            return index1 < index2
        }
        
        return self.sorted(by: comparator)
    }
}

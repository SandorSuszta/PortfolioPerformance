import Foundation

enum PersistantDataType: String {
    case watchlist
    case recentSearches
    
    var dictionaryKey: String {
        return rawValue
    }
}

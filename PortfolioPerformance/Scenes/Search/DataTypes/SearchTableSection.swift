import Foundation

enum SearchTableSection {
    case searchResults
    case recentSearches
    case trendingCoins
    
    var title: String {
        switch self {
        case .recentSearches:
            return "Recent Searches"
        case .searchResults:
            return ""
        case .trendingCoins:
            return "Trending Coins"
        }
    }
    
    var buttonTitle: String {
        switch self {
        case .recentSearches:
            return "Clear"
        default:
            return ""
        }
    }
}

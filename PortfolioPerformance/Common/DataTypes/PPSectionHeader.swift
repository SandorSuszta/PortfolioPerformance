import Foundation

enum PPSectionHeader {
    case searching
    case recentSearches
    case trendingCoins
    
    var title: String {
        switch self {
        case .recentSearches:
            return "Recent Searches"
        case .searching:
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

import UIKit

enum WatchlistSortOption {
    case custom
    case alphabetical
    case topMarketCap
    case topWinners
    case topLosers
    
    static let sortMenuName = "Sort options"
    
    var name: String {
        switch self {
        case .alphabetical: return "A-Z"
        case .custom: return "Custom sort"
        case .topLosers: return "Top Losers"
        case .topMarketCap: return "Market Cap"
        case .topWinners: return "Top Winners"
        }
    }
    
    var logo: UIImage? {
        switch self {
        case .alphabetical: return UIImage(systemName: "character")
        case .custom: return UIImage(systemName: "star")
        case .topLosers: return UIImage(systemName: "arrow.down.right")
        case .topMarketCap: return UIImage(systemName: "banknote")
        case .topWinners: return UIImage(systemName: "arrow.up.right")
        }
    }
}

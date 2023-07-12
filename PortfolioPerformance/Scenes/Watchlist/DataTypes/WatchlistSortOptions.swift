import UIKit

enum WatchlistSortOption {
    case customList([String])
    case alphabetical
    case topMarketCap
    case topWinners
    case topLosers
    
    static let sortMenuName = "Sort options"
    
    var name: String {
        switch self {
        case .alphabetical: return "A-Z"
        case .customList: return "Custom sort"
        case .topLosers: return "Top Losers"
        case .topMarketCap: return "Market Cap"
        case .topWinners: return "Top Winners"
        }
    }
    
    var logo: UIImage? {
        switch self {
        case .alphabetical: return UIImage(systemName: "character")
        case .customList: return UIImage(systemName: "star")
        case .topLosers: return UIImage(systemName: "arrow.down.right")
        case .topMarketCap: return UIImage(systemName: "banknote")
        case .topWinners: return UIImage(systemName: "arrow.up.right")
        }
    }
    
    var sortComparator: (CryptoCurrencyCellViewModel, CryptoCurrencyCellViewModel) -> Bool {
        switch self {
            
        case .alphabetical:
            return { $0.name < $1.name }
            
        case .topMarketCap:
            return { $0.coinModel.marketCap ?? 0 > $1.coinModel.marketCap ?? 0 }
            
        case .topWinners:
            return { $0.coinModel.priceChangePercentage24H ?? 0 > $1.coinModel.priceChangePercentage24H ?? 0 }
            
        case .topLosers:
            return { $0.coinModel.priceChangePercentage24H ?? 0 < $1.coinModel.priceChangePercentage24H ?? 0 }
            
        case .customList(let list):
            let sortComparator: (CryptoCurrencyCellViewModel, CryptoCurrencyCellViewModel) -> Bool = { (element1, element2) in
                guard let index1 = list.firstIndex(of: element1.coinModel.id),
                      let index2 = list.firstIndex(of: element2.coinModel.id)
                else { return false }
                
                return index1 < index2
            }
            return sortComparator
        }
    }
}

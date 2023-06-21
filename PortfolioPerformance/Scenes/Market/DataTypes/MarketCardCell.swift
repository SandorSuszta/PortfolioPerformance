import Foundation


enum MarketCardCell {
    case greedAndFear
    case totalMarketCap
    case bitcoinDominance
    
    var title: String {
        switch self {
        case .totalMarketCap:
            return "Market Cap"
        case .bitcoinDominance:
            return "BTC Dominance"
        case .greedAndFear:
            return "Greed & Fear"
        }
    }
}

import Foundation

enum MarketCard: Hashable {
    case loading
    case dataReceived(MarketCardCellViewModel)
}

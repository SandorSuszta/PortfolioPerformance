import Foundation

enum MarketCard: Hashable {
    case loading(index: Int)
    case dataReceived(MarketCardCellViewModel)
}

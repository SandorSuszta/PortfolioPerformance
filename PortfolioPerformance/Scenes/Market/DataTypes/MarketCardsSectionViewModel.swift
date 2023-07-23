import Foundation

enum MarketCard: Hashable {
    case loading(id: UUID)
    case dataReceived(MarketCardCellViewModel)
}

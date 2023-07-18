import Foundation

///Used as item identifier within MarketDiffableDataSource.
///It wraps the different viewModels/models to be used in single data source
enum MarketItem: Hashable {
    case marketCard(MarketCard)
    case cryptoCoinCell(CryptoCoinCell)
}

///Hashable conformance is required by DiffableDataSource
//extension MarketItem: Hashable {
//    func hash(into hasher: inout Hasher) {
//        switch self {
//
//        case .marketCard(let card):
//            switch card {
//            case .dataReceived(let model):
//                hasher.combine(model)
//            case .loading(let index):
//                hasher.combine(index)
//            }
//
//        case .cryptoCoinCell(let cell):
//            switch cell {
//            case .dataReceived(let model):
//                hasher.combine(model)
//            case .loading(let index):
//                hasher.combine(index)
//            }
//        }
//    }
    
//    static func ==(lhs: MarketItem, rhs: MarketItem) -> Bool {
//        switch (lhs, rhs) {
//        case (.marketCard(let lhsCard), .marketCard(let rhsCard)):
//            return lhsCard == rhsCard
//        case (.cryptoCoinCell(let lhsViewModel), .cryptoCoinCell(let rhsViewModel)):
//            return lhsViewModel == rhsViewModel
//        default:
//            return false
//        }
//    }
//}

import Foundation

///Used as item identifier within MarketDiffableDataSource.
///It wraps the different viewModels/models to be used in single data source
enum MarketItem {
    case marketCard(Cell<MarketCardCellViewModel>)
    case cryptoCoinCell(Cell<CoinModel>)
}

///Hashable conformance is required by DiffableDataSource
extension MarketItem: Hashable {
    func hash(into hasher: inout Hasher) {
        switch self {
        case .marketCard(let viewModel):
            hasher.combine(viewModel)
        case .cryptoCoinCell(let model):
            hasher.combine(model)
        }
    }
    
    static func ==(lhs: MarketItem, rhs: MarketItem) -> Bool {
        switch (lhs, rhs) {
        case (.marketCard(let lhsViewModel), .marketCard(let rhsViewModel)):
            return lhsViewModel == rhsViewModel
        case (.cryptoCoinCell(let lhsViewModel), .cryptoCoinCell(let rhsViewModel)):
            return lhsViewModel == rhsViewModel
        default:
            return false
        }
    }
}

import Foundation

///Used as item identifier within MarketDiffableDataSource.
///It wraps the different viewModels/models to be used in single data source
enum MarketItemViewModel {
    case marketCard(viewModel: MarketCardCellViewModel)
    case cryptoCoinCell(model: CoinModel)
}

///Hashable conformance is required by DiffableDataSource
extension MarketItemViewModel: Hashable {
    func hash(into hasher: inout Hasher) {
        switch self {
        case .marketCard(let viewModel):
            hasher.combine(viewModel)
        case .cryptoCoinCell(let model):
            hasher.combine(model)
        }
    }
    
    static func ==(lhs: MarketItemViewModel, rhs: MarketItemViewModel) -> Bool {
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

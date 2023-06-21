import Foundation

enum MarketItemViewModel {
    case marketCard(viewModel: MarketCardCellViewModel)
    case cryptoCoinCell(model: CoinModel)
}

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

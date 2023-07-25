import Foundation

///Used as item identifier within MarketDiffableDataSource.
///It wraps the different viewModels/models to be used in single data source
enum MarketItem: Hashable {
    case marketCard(MarketCard)
    case cryptoCoinCell(CryptoCoinCell)
}

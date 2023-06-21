import UIKit

/// A custom data source class for a UICollectionView. CollectionView has two different sections each with different cells and view models.
final class MarketDataSource: UICollectionViewDiffableDataSource<MarketSection, MarketItemViewModel> {
    
    //MARK: - Init
    
    /// Initializer handles the cell configuration logic based on the type of the item. It differentiates between two types of items: "Market Cards" and "CryptoCoins".
    ///
    /// For "Market Cards", it further distinguishes between different cell types based on the cellType property of the associated view model.
    /// It creates the corresponding cell instances (MarketCardMetricCell or MarketCardGreedAndFearCell), configures them with the associated view model, and returns the configured cell.
    init(collectionView: UICollectionView) {
        super.init(collectionView: collectionView) { collectionView, indexPath, item in
           
            switch item {
                
                //Market Cards
            case .marketCard(let viewModel):
                
                switch viewModel.cellType {
                    
                case .bitcoinDominance, .totalMarketCap:
                    let cell = MarketCardMetricCell()
                    cell.configure(with: viewModel)
                    return cell
                    
                case .greedAndFear:
                    let cell = MarketCardGreedAndFearCell()
                    cell.configure(with: viewModel)
                    return cell
                }
                
                //CryptoCoins
            case .cryptoCoinCell(let model):
                guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: CryptoCurrencyCell.identifier,
                    for: indexPath
                ) as? CryptoCurrencyCollectionViewCell
                else { return UICollectionViewCell() }
                
                cell.configureCell(with: CryptoCurrencyCellViewModel(coinModel: model))
                return cell
            }
        }
    }
}

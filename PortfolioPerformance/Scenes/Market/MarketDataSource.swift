import UIKit

/// A custom data source class for a UICollectionView. CollectionView has two different sections each with different cells and view models.
final class MarketDataSource: UICollectionViewDiffableDataSource<MarketSection, MarketItem> {
    
    weak var sortHeaderDelegate: SortSectionHeaderDelegate?
    
    //MARK: - Init
    /// Initializer handles the cell configuration logic based on the type of the item. It differentiates between two types of items: "Market Cards" and "CryptoCoins".
    ///
    /// For "Market Cards", it further distinguishes between different cell types based on the cellType property of the associated view model.
    /// It creates the corresponding cell instances (MarketCardMetricCell or MarketCardGreedAndFearCell), configures them with the associated view model, and returns the configured cell.
    init(collectionView: UICollectionView, sortHeaderDelegate: SortSectionHeaderDelegate) {
        self.sortHeaderDelegate = sortHeaderDelegate
        
        super.init(collectionView: collectionView) { collectionView, indexPath, item in
            
            switch item {
                
                //Market Cards
            case .marketCard(let viewModel):
                
                switch viewModel.cellType {
                    
                case .bitcoinDominance, .totalMarketCap:
                    guard let cell = collectionView.dequeueReusableCell(
                        withReuseIdentifier: MarketCardMetricCell.reuseID,
                        for: indexPath
                    ) as? MarketCardMetricCell else { return UICollectionViewCell() }
                    
                    cell.configure(with: viewModel)
                    return cell
                    
                case .greedAndFear:
                    guard let cell = collectionView.dequeueReusableCell(
                        withReuseIdentifier: MarketCardGreedAndFearCell.reuseID,
                        for: indexPath
                    ) as? MarketCardGreedAndFearCell else { return UICollectionViewCell() }
                    
                    cell.configure(with: viewModel)
                    return cell
                }
                
                //CryptoCoins
            case .cryptoCoinCell(let model):
                guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: CryptoCurrencyCollectionViewCell.reuseID,
                    for: indexPath
                ) as? CryptoCurrencyCollectionViewCell else { return UICollectionViewCell() }
                
                cell.imageDownloader = ImageDownloader()
                cell.configureCell(with: CryptoCurrencyCellViewModel(coinModel: model))
                return cell
            }
        }
    }
    
    
    //MARK: - Data Source methods
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        guard let headerView = collectionView.dequeueReusableSupplementaryView(
            ofKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: SortSectionHeader.reuseID,
            for: indexPath
        ) as? SortSectionHeader else { return UICollectionReusableView() }
        
        headerView.delegate = sortHeaderDelegate
        return headerView
    }
}

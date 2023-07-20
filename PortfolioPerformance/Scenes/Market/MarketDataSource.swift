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
                
            case .marketCard(let card):
                return MarketDataSource.makeMarketCardCell(collectionView: collectionView, indexPath: indexPath, item: card)
                
            case .cryptoCoinCell(let cell):
                return MarketDataSource.makeCryptoCoinCell(collectionView: collectionView, indexPath: indexPath, item: cell)
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
    
extension MarketDataSource {
    
    // MARK: - MarketCardCell factory method
    
    private static func makeMarketCardCell(
        collectionView: UICollectionView,
        indexPath: IndexPath,
        item: MarketCard
    ) -> UICollectionViewCell {
        
        switch item {
            
        case .dataReceived(let viewModel):
            
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
            
        case .loading:
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: MarketCardMetricCell.reuseID,
                for: indexPath
            ) as? MarketCardMetricCell else { return UICollectionViewCell() }
            return cell
        }
    }
    
    // MARK: - CryptoCoinCell factory method
    
    private static func makeCryptoCoinCell(
        collectionView: UICollectionView,
        indexPath: IndexPath,
        item: CryptoCoinCell
    ) -> UICollectionViewCell {
        
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: CryptoCurrencyCollectionViewCell.reuseID,
                for: indexPath
            ) as? CryptoCurrencyCollectionViewCell else { return UICollectionViewCell() }
            
        if case .dataReceived(let viewModel) = item {
            cell.imageDownloader = ImageDownloader()
            cell.configureCell(with: viewModel)
        }
            return cell
    }
}

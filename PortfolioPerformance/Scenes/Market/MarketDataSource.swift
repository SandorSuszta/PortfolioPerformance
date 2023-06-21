import UIKit

final class MarketDataSource: UICollectionViewDiffableDataSource<MarketSection, MarketItemViewModel> {
    
    //MARK: - Init
    
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

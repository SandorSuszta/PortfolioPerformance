import Foundation

final class WatchlistViewModel {
    
    //MARK: - Properties
    
    private let networkingService: NetworkingServiceProtocol
    private var cachedWatchlist: [String]?
    
    public var cellViewModels: ObservableObject<[CryptoCurrencyCellViewModel]> = ObservableObject(value:[])
    public var errorMessage: ObservableObject<String>?
    
    //MARK: - Init
    
    init(networkingService: NetworkingServiceProtocol) {
        self.networkingService = networkingService
        loadWatchlistDataIfNeeded(watchlist: UserDefaultsService.shared.watchlistIDs, sortOption: .custom)
    }
    
    //MARK: - API
    
    func sortCellViewModels(by option: WatchlistSortOption) {
        guard let viewModels = cellViewModels.value else { return }
        cellViewModels.value = sorted(viewModels, by: option)
    }
    
    func reorderCellViewModels(from sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        guard let cellViewModel = cellViewModels.value?[sourceIndexPath.row] else { return }
        cellViewModels.value?.remove(at: sourceIndexPath.row)
        cellViewModels.value?.insert(cellViewModel, at: destinationIndexPath.row)
    }
    
    func loadWatchlistDataIfNeeded(watchlist: [String], sortOption: WatchlistSortOption) {
        
        guard cachedWatchlist != watchlist else { return }
        
        networkingService.getDataForList(ofIDs: watchlist) { result in
            switch result {
            case .success(let coinModels):
                
                //Transform array of coin models into array of cell view models
                let viewModels: [CryptoCurrencyCellViewModel] = coinModels.compactMap({ CryptoCurrencyCellViewModel(coinModel: $0)
                })
                
                let sortedViewModels = self.sorted(viewModels, by: sortOption)
                
                self.cellViewModels.value = sortedViewModels
                self.cachedWatchlist = watchlist
                
            case .failure(let error):
                self.errorMessage?.value = error.rawValue
            }
        }
    }
    
    // MARK: - API
    
    private func sorted(_ viewModels: [CryptoCurrencyCellViewModel], by option: WatchlistSortOption) -> [CryptoCurrencyCellViewModel] {
        
        let sortedCellViewModels: [CryptoCurrencyCellViewModel]
        
        switch option {
        case .custom:
            sortedCellViewModels = viewModels.sorted(by: sortByPositionInWatchlist)
        case .alphabetical:
            sortedCellViewModels = viewModels.sorted { $0.name < $1.name }
        case .topMarketCap:
            sortedCellViewModels = viewModels.sorted { $0.coinModel.marketCap ?? 0 > $1.coinModel.marketCap ?? 0 }
        case .topWinners:
            sortedCellViewModels = viewModels.sorted { $0.coinModel.priceChangePercentage24H ?? 0 > $1.coinModel.priceChangePercentage24H ?? 0 }
        case .topLosers:
            sortedCellViewModels = viewModels.sorted { $0.coinModel.priceChangePercentage24H ?? 0 < $1.coinModel.priceChangePercentage24H ?? 0 }
        }
        
        return sortedCellViewModels
    }
    
    private func sortByPositionInWatchlist(_ element1: CryptoCurrencyCellViewModel, _ element2: CryptoCurrencyCellViewModel) -> Bool {
        let watchlist = UserDefaultsService.shared.watchlistIDs
        
        guard let index1 = watchlist.firstIndex(of: element1.coinModel.id),
              let index2 = watchlist.firstIndex(of: element2.coinModel.id)
        else { return false }
        
        return index1 < index2
    }
}

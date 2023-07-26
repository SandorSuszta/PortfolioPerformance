import Foundation

final class WatchlistViewModel {
    
    private var cachedWatchlist: [String]?
    
    var watchlist: [String] {
        watchlistStore.watchlist
    }
    
    var isWatchlistEmpty: Bool {
        watchlistStore.watchlist.isEmpty
    }
    
    // MARK: - Dependencies
    
    private let networkingService: NetworkingServiceProtocol
    private let watchlistStore: WatchlistStoreProtocol
    
    // MARK: - Observables
    
    public var cellViewModels: ObservableObject<[CryptoCurrencyCellViewModel]> = ObservableObject(value:[])
    public var errorsState: ObservableObject<ErrorState> = ObservableObject(value: .noErrors)
    
    //MARK: - Init
    
    init(networkingService: NetworkingServiceProtocol, watchlistStore: WatchlistStoreProtocol) {
        self.networkingService = networkingService
        self.watchlistStore = watchlistStore
        loadWatchlistData(forSortOption: .custom)
    }
    
    convenience init() {
        self.init(networkingService: DefaultNetworkingService(), watchlistStore: WatchlistStore())
    }
    
    //MARK: - API
    
    func sortCellViewModels(by option: WatchlistSortOption) {
        cellViewModels.value = sorted(cellViewModels.value, by: option)
    }
    
    func reorderCellViewModels(from sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let cellViewModel = cellViewModels.value[sourceIndexPath.row]
        cellViewModels.value.remove(at: sourceIndexPath.row)
        cellViewModels.value.insert(cellViewModel, at: destinationIndexPath.row)
    }
    
    func reorderWatchlist(sourceIndex: Int, destinationIndex: Int) {
        watchlistStore.reorderWatchlist(sourceIndex: sourceIndex, destinationIndex: destinationIndex)
    }
    
    func loadWatchlistData(forSortOption option: WatchlistSortOption) {
        guard cachedWatchlist != watchlist else { return }
        
        networkingService.getDataForList(ofIDs: watchlist) { result in
            switch result {
            case .success(let coinModels):
                
                //Transform array of coin models into array of cell view models
                let viewModels: [CryptoCurrencyCellViewModel] = coinModels.compactMap({ CryptoCurrencyCellViewModel(coinModel: $0)
                })
                
                let sortedViewModels = self.sorted(viewModels, by: option)
                
                self.cellViewModels.value = sortedViewModels
                self.cachedWatchlist = self.watchlist
                
            case .failure(let error):
                self.errorsState.value = .error(error)
            }
        }
    }
    
    func resetError() {
        errorsState.value = .noErrors
    }
    
    // MARK: - Private
    
    private func sorted(_ viewModels: [CryptoCurrencyCellViewModel], by option: WatchlistSortOption) -> [CryptoCurrencyCellViewModel] {
        
        switch option {
        case .alphabetical:
            return viewModels.sorted { $0.name < $1.name }
        case .topMarketCap:
            return viewModels.sorted { $0.coinModel.marketCap ?? 0 > $1.coinModel.marketCap ?? 0 }
        case .topWinners:
            return viewModels.sorted { $0.coinModel.priceChangePercentage24H ?? 0 > $1.coinModel.priceChangePercentage24H ?? 0 }
        case .topLosers:
            return viewModels.sorted { $0.coinModel.priceChangePercentage24H ?? 0 < $1.coinModel.priceChangePercentage24H ?? 0 }
        case .custom:
            /// Custom case sorts viewModels in same order as saved in watchlist

            let sortComparator: (CryptoCurrencyCellViewModel, CryptoCurrencyCellViewModel) -> Bool = { (element1, element2) in
                guard let index1 = self.watchlist.firstIndex(of: element1.coinModel.id),
                      let index2 = self.watchlist.firstIndex(of: element2.coinModel.id)
                else { return false }
                
                return index1 < index2
            }
            
            return viewModels.sorted(by: sortComparator)
        }
    }
}

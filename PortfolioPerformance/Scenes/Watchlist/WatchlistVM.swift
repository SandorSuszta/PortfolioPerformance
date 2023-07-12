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
    public var errorMessage: ObservableObject<String>?
    
    //MARK: - Init
    
    init(networkingService: NetworkingServiceProtocol, watchlistStore: WatchlistStoreProtocol) {
        self.networkingService = networkingService
        self.watchlistStore = watchlistStore
        loadWatchlistData(forSortOption: .customList(watchlistStore.watchlist))
    }
    
    convenience init() {
        self.init(networkingService: NetworkingService(), watchlistStore: WatchlistStore())
    }
    
    //MARK: - API
    
    func sortCellViewModels(by option: WatchlistSortOption) {
        guard let viewModels = cellViewModels.value else { return }
        cellViewModels.value = viewModels.sorted(by: option.sortComparator)
    }
    
    func reorderCellViewModels(from sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        guard let cellViewModel = cellViewModels.value?[sourceIndexPath.row] else { return }
        cellViewModels.value?.remove(at: sourceIndexPath.row)
        cellViewModels.value?.insert(cellViewModel, at: destinationIndexPath.row)
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
                
                let sortedViewModels = viewModels.sorted(by: option.sortComparator)
                
                self.cellViewModels.value = sortedViewModels
                self.cachedWatchlist = self.watchlist
                
            case .failure(let error):
                self.errorMessage?.value = error.rawValue
            }
        }
    }
}

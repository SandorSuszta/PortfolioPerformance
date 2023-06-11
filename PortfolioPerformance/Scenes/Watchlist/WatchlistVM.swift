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
        loadWatchlistDataIfNeeded(watchlist: UserDefaultsService.shared.watchlistIDs)
    }
    
    //MARK: - Methods
    
    func reorderCellViewModels(from sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        guard let cellViewModel = cellViewModels.value?[sourceIndexPath.row] else { return }
        cellViewModels.value?.remove(at: sourceIndexPath.row)
        cellViewModels.value?.insert(cellViewModel, at: destinationIndexPath.row)
    }
    
    func loadWatchlistDataIfNeeded(watchlist: [String]) {
        
        guard cachedWatchlist != watchlist else { return }
        
        networkingService.getDataForList(ofIDs: watchlist) { result in
            switch result {
            case .success(let coinModels):
        
                //Use the same order as in query list
                let sortedCoinModels = coinModels.sorted(byList: watchlist)
                
                //Transform array of coin models into array of cell view models
                let viewModels: [CryptoCurrencyCellViewModel] = sortedCoinModels.compactMap({ CryptoCurrencyCellViewModel(coinModel: $0)
                })
                
                self.cellViewModels.value = viewModels
                self.cachedWatchlist = watchlist
                
            case .failure(let error):
                self.errorMessage?.value = error.rawValue
            }
        }
    }
}
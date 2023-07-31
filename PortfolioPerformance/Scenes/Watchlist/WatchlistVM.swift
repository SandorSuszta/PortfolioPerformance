import Foundation

final class WatchlistViewModel {
    
    private var cachedWatchlist: [String]?
    
    private(set) var selectedSortOption: WatchlistSortOption = .custom
    
    var watchlist: [String] {
        watchlistRepository.watchlist
    }
    
    var isWatchlistEmpty: Bool {
        watchlistRepository.watchlist.isEmpty
    }
    
    // MARK: - Dependencies
    
    private let networkingService: NetworkingServiceProtocol
    private let watchlistRepository: WatchlistRepository
    
    // MARK: - Observables
    
    var cellViewModels: ObservableObject<[CryptoCurrencyCellViewModel]> = ObservableObject(value:[])
    var errorsState: ObservableObject<ErrorState> = ObservableObject(value: .noErrors)
    
    //MARK: - Init
    
    init(networkingService: NetworkingServiceProtocol, watchlistStore: WatchlistRepository) {
        self.networkingService = networkingService
        self.watchlistRepository = watchlistStore
        loadWatchlistData()
    }
    
    convenience init() {
        self.init(networkingService: DefaultNetworkingService(), watchlistStore: DefaultWatchlistStore())
    }
    
    //MARK: - API
    
    func sortOptionDidChange(to option: WatchlistSortOption) {
        selectedSortOption = option
        cellViewModels.value = sorted(cellViewModels.value, by: option)
    }
    
    func deleteFromWatchlist(_ id: String) {
        watchlistRepository.delete(id: id)
    }
    
    func reorderWatchlist(sourceIndex: Int, destinationIndex: Int) {
        reorderCellViewModels(from: sourceIndex, to: destinationIndex)
        watchlistRepository.reorderWatchlist(sourceIndex: sourceIndex, destinationIndex: destinationIndex)
    }
    
    func loadWatchlistData() {
        guard cachedWatchlist != watchlist else {
            cellViewModels.value = cellViewModels.value
            return
        }
        
        networkingService.getDataFor(IDs: watchlist) { result in
            switch result {
            case .success(let coinModels):
                
                //Transform array of coin models into array of cell view models
                let viewModels: [CryptoCurrencyCellViewModel] = coinModels.compactMap({ CryptoCurrencyCellViewModel(coinModel: $0)
                })
                
                let sortedViewModels = self.sorted(viewModels, by: self.selectedSortOption)
                
                self.cellViewModels.value = sortedViewModels
                self.cachedWatchlist = self.watchlist
                
            case .failure(let error):
                self.errorsState.value = .error(error)
            }
        }
    }
    
    // MARK: - Private
    
    private func reorderCellViewModels(from sourceIndex: Int, to destinationIndex: Int) {
        let cellViewModel = cellViewModels.value[sourceIndex]
        cellViewModels.value.remove(at: sourceIndex)
        cellViewModels.value.insert(cellViewModel, at: destinationIndex)
    }
    
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

extension  WatchlistViewModel: ErrorAlertDelegate {
    func didPressRetry() {
        errorsState.value = .noErrors
        loadWatchlistData()
    }
}

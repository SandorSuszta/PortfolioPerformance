import Foundation

final class WatchlistViewModel {
    //MARK: - Properties
    private let networkingService: NetworkingServiceProtocol
    
    public var cellViewModels: ObservableObject<[CryptoCurrencyCellViewModel]> = ObservableObject(value:[])
    public var errorMessage: ObservableObject<String>?
    
    //MARK: - Init
    init(networkingService: NetworkingServiceProtocol) {
        self.networkingService = networkingService
        loadWatchlistCryptoCurrenciesData(list: UserDefaultsService.shared.watchlistIDs)
    }
    
    //MARK: - Methods
    func moveCellViewModel(from sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        guard let cellViewModel = cellViewModels.value?[sourceIndexPath.row] else { return }
        cellViewModels.value?.remove(at: sourceIndexPath.row)
        cellViewModels.value?.insert(cellViewModel, at: destinationIndexPath.row)
    }
    
    func loadWatchlistCryptoCurrenciesData(list: [String]) {
        
        networkingService.getDataForList(ofIDs: list) { result in
            switch result {
            case .success(let coinModels):
                let list = UserDefaultsService.shared.watchlistIDs
                //Use the same order as in saved list
                let sortedCoinModels = coinModels.sorted {
                    list.firstIndex(of: $0.id) ?? 0 > list.firstIndex(of: $1.id) ?? 0
                }
                //Transform array of coin models into array of cell view models
                let viewModels: [CryptoCurrencyCellViewModel] = sortedCoinModels.compactMap({ CryptoCurrencyCellViewModel(coinModel: $0)
                })
                
                self.cellViewModels.value = viewModels
                
            case .failure(let error):
                self.errorMessage?.value = error.rawValue
            }
        }
    }
}

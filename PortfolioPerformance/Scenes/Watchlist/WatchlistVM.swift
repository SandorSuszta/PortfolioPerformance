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
   func loadWatchlistCryptoCurrenciesData(list: [String]) {
        
        networkingService.getDataForList(ofIDs: list) { result in
            switch result {
            case .success(let coinModels):
                //Transform array of coin models into array of cell view models
                let viewModels: [CryptoCurrencyCellViewModel] = coinModels.compactMap({ CryptoCurrencyCellViewModel(coinModel: $0)
                })
                self.cellViewModels.value = viewModels
               
            case .failure(let error):
                self.errorMessage?.value = error.rawValue
            }
        }
    }
}

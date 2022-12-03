import Foundation

class WatchlistViewModel {
    
    public var cellViewModels: ObservableObject<[CryptoCurrencyCellViewModel]> = ObservableObject(value:[])
    
    public var errorMessage: ObservableObject<String>?
    
    public func loadWatchlistCryptoCurrenciesData(list: [String]) {
        
        NetworkingManager.shared.requestDataForList(list: list) { result in
            switch result {
            case .success(let coinModels):
                //Transform array of coin models into array of cell view models
                let viewModels: [CryptoCurrencyCellViewModel] = coinModels.compactMap({ .init(coinModel: $0)
                })
                self.cellViewModels.value = viewModels
               
            case .failure(let error):
                self.errorMessage?.value = error.rawValue
            }
        }
    }
}

import Foundation

class AddTransactionViewModel {
    
    //MARK: - Properties
    
    private let defaultIDs = ["bitcoin", "ethereum", "binancecoin", "ripple", "dogecoin", "cardano", "matic-network", "polkadot"]
    
    public var searchResultCellModels: ObservableObject<[SearchResult]> = ObservableObject(value: nil)
    
    public var defaultModels: ObservableObject<[SearchResult]> = ObservableObject(value: nil)
    
    public var errorMessage: ObservableObject<String> = ObservableObject(value: nil)
    
    //MARK: - Init
    
    init() {
        getDefaultModels()
    }
    
    //MARK: - Public methods
    
    public func getDefaultModels() {
        
        NetworkingManager.shared.requestDataForList(list: createEightIDsList()) { result in
            
            switch result {
            case .success(let coinModels):
                
                let cellModels: [SearchResult] = coinModels.compactMap {
                    SearchResult(
                        id: $0.id,
                        name: $0.name,
                        symbol: $0.symbol,
                        large: $0.image
                    )
                }
                
                let orderedCellModels = self.reorderModelsBasedOnQueryList(
                    models: cellModels,
                    queryList: self.createEightIDsList()
                )
                
                self.defaultModels.value = orderedCellModels
                
            case .failure(let error):
                self.errorMessage.value = error.rawValue
            }
        }
    }
    
    public func getSearchResults(query: String) {
        NetworkingManager.shared.searchWith(query: query) { result in
            switch result {
            case.success(let response):
                self.searchResultCellModels.value = Array(response.coins.prefix(8))
                
            case .failure(let error):
                self.errorMessage.value = error.rawValue
            }
        }
    }
    
    //MARK: - Private methods
    
    private func createEightIDsList() -> [String] {
        let recentTransactionIDs = UserDefaultsManager.shared.recentTransactionsIDs
        
        if recentTransactionIDs.count < 8 {
            let supplementList = Array(defaultIDs.prefix(8 - recentTransactionIDs.count))
            return recentTransactionIDs + supplementList
        }
        
        return recentTransactionIDs
    }
    
    private func reorderModelsBasedOnQueryList(models: [SearchResult], queryList: [String]) -> [SearchResult] {
        
        let sortedModels = models.sorted {
            queryList.firstIndex(of: $0.id) ?? 0 < queryList.firstIndex(of: $1.id) ?? 0
        }
        
        return sortedModels
    }
}

import Foundation

class SearchScreenViewModel {
    let networkingService: NetworkingServiceProtocol
    
    //MARK: - Observable properties
    
    var defaultCellModels: ObservableObject<[[SearchResult]]> = ObservableObject(value: [[],[]])
    
    var searchResultCellModels: ObservableObject<[SearchResult]> = ObservableObject(value: nil)
    
    var errorMessage: ObservableObject<String> = ObservableObject(value: nil)
    
    //MARK: - Init
    
    init(networkingService: NetworkingServiceProtocol) {
        self.networkingService = networkingService
        updateRecentSearches()
        getTrendingCoinsModels()
    }
    
    //MARK: - Public methods
    
    func updateRecentSearches() {
        
        if !UserDefaultsService.shared.recentSearchesIDs.isEmpty {
            getRecentSearchesModels()
        }
    }
    
    func updateSearchResults(query: String) {
        
        networkingService.searchWith(query: query) { result in
            switch result {
            case.success(let response):
                self.searchResultCellModels.value = Array(response.coins.prefix(6)).sortedByPrefix(query)
                
            case .failure(let error):
                self.errorMessage.value = error.rawValue
            }
        }
    }
    
    func clearSearchModels() {
        self.searchResultCellModels.value = nil
    }
    
    func clearRecentSearches() {
        defaultCellModels.value?[0] = []
    }
    
    //MARK: - Private methods

    private func getRecentSearchesModels() {
        
        guard !UserDefaultsService.shared.recentSearchesIDs.isEmpty else { return }
        
        networkingService.getDataForList(ofIDs: UserDefaultsService.shared.recentSearchesIDs) { result in
            switch result {
            case .success(let coinModels):
                
                let recentSearchesModels: [SearchResult] = coinModels.compactMap {
                    SearchResult(
                        id: $0.id,
                        name: $0.name,
                        symbol: $0.symbol,
                        large: $0.image
                    )
                }
                
                let list = UserDefaultsService.shared.recentSearchesIDs
                
                //Use the same order as in saved list
                
                let sortedModels = recentSearchesModels.sorted(byList: list)
                
                self.defaultCellModels.value?[0] = sortedModels.reversed()
                
            case .failure(let error):
                self.errorMessage.value = error.rawValue
            }
        }
    }
    
    private func getTrendingCoinsModels() {
        
       networkingService.getTrendingCoins { result in

            switch result {
            case .success(let response):
                let trendingCoins: [SearchResult] = response.coins.compactMap {
                    $0.item
                }
                self.defaultCellModels.value?[1] = trendingCoins
            case .failure(let error):
                self.errorMessage.value = error.rawValue
            }
        }
    }
}

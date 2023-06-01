import Foundation

class SearchScreenViewModel {
    let networkingService: NetworkingServiceProtocol
    
    //MARK: - Observable properties
    var isRecentSearchesEmpty: Bool {
        defaultCellModels.value?[0].isEmpty ?? true
    }
    
    var defaultCellModels: ObservableObject<[[SearchResult]]> = ObservableObject(value: [[],[]])
    
    var searchResultCellModels: ObservableObject<[SearchResult]> = ObservableObject(value: nil)
    
    var errorMessage: ObservableObject<String> = ObservableObject(value: nil)
    
    //MARK: - Init
    
    init(networkingService: NetworkingServiceProtocol) {
        self.networkingService = networkingService
        fetchData()
    }
    
    //MARK: - Public methods
    
    func updateRecentSearches() {
        
        if !UserDefaultsService.shared.recentSearchesIDs.isEmpty {
            getRecentSearchesModels { models in
                self.defaultCellModels.value?[0] = models.reversed()
            }
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
    
    private func getRecentSearchesModels(completion: @escaping ([SearchResult]) -> Void) {
        
        guard !UserDefaultsService.shared.recentSearchesIDs.isEmpty else { return completion([]) }
        
        networkingService.getDataForList(ofIDs: UserDefaultsService.shared.recentSearchesIDs) { result in
            switch result {
            case .success(let coinModels):
                
                let recentSearchesModels: [SearchResult] = coinModels.compactMap {
                    SearchResult(
                        id: $0.id,
                        name: $0.name,
                        symbol: $0.symbol,
                        image: $0.image
                    )
                }
                
                let recentSearchesList = UserDefaultsService.shared.recentSearchesIDs
                
                let sortedModels = recentSearchesModels.sorted(byList: recentSearchesList)
                
                completion(sortedModels)
                
            case .failure(let error):
                self.errorMessage.value = error.rawValue
            }
        }
    }
    
    private func getTrendingCoinsModels(completion: @escaping ([SearchResult]) -> Void) {
        
        networkingService.getTrendingCoins { result in
            
            switch result {
            case .success(let response):
                let trendingCoins: [SearchResult] = response.coins.compactMap {
                    $0.item
                }
                completion(trendingCoins)
             
            case .failure(let error):
                self.errorMessage.value = error.rawValue
            }
        }
    }
    
    private func fetchData() {
        let dispatchGroup = DispatchGroup()
        
        var recentSearchesModels: [SearchResult] = []
        var trendingCoins: [SearchResult] = []
        
        dispatchGroup.enter()
        getRecentSearchesModels { models in
            recentSearchesModels = models
            dispatchGroup.leave()
        }
        
        dispatchGroup.enter()
        getTrendingCoinsModels { models in
            trendingCoins = models
            dispatchGroup.leave()
        }
        
        dispatchGroup.notify(queue: .main) {
            self.defaultCellModels.value = [recentSearchesModels.reversed(), trendingCoins]
        }
    }
}

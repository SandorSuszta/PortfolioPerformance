import Foundation

final class SearchScreenViewModel {
    
    // MARK: - Dependencies
    
    private let searchService: SearchCryptocurrencyServiceProtocol
    private let recentSearchesRepository: RecentSearchesRepositoryProtocol
    
    //MARK: - Observables
    
    var recentSearchesModels: ObservableObject<[SearchResult]?> = ObservableObject(value: nil)
    var trendingCoinsModels: ObservableObject<[SearchResult]?> = ObservableObject(value: nil)
    var searchResultCellModels: ObservableObject<[SearchResult]?> = ObservableObject(value: nil)
    var errorsState: ObservableObject<ErrorState> = ObservableObject(value: .noErrors)
    
    //MARK: - Init
    
    init(searchService: SearchCryptocurrencyServiceProtocol,
         recentSearchesRepository: RecentSearchesRepositoryProtocol) {
        self.searchService = searchService
        self.recentSearchesRepository = recentSearchesRepository
        fetchData()
    }
    
    //MARK: - Interface
    
    var isRecentSearchesEmpty: Bool {
        recentSearchesRepository.isRecentSearchesEmpty
    }
    
    func fetchData() {
        let dispatchGroup = DispatchGroup()
        
        var recentSearches: [SearchResult] = []
        var trendingCoins: [SearchResult] = []
        
        dispatchGroup.enter()
        getRecentSearchesModels { models in
            recentSearches = models
            dispatchGroup.leave()
        }
        
        dispatchGroup.enter()
        getTrendingCoinsModels { models in
            trendingCoins = models
            dispatchGroup.leave()
        }
        
        dispatchGroup.notify(queue: .main) {
            (self.recentSearchesModels.value, self.trendingCoinsModels.value) = (recentSearches, trendingCoins)
        }
    }
    
    func updateRecentSearches() {
        isRecentSearchesEmpty
        ? recentSearchesModels = ObservableObject(value: [])
        : getRecentSearchesModels { models in
            self.recentSearchesModels.value = models
        }
    }
    
    func updateSearchResults(query: String) {
        
        networkingService.searchWith(query: query) { result in
            switch result {
            case.success(let response):
                self.searchResultCellModels.value = Array(response.coins.prefix(6)).sortedByPrefix(query)
                
            case .failure(let error):
                self.errorsState.value = .error(error)
            }
        }
    }
    
    func clearRecentSearches() {
        recentSearchesModels.value = []
        recentSearchesRepository.clearRecentSearches()
    }
    
    func resetError() {
        errorsState.value = .noErrors
    }
    
    func saveSearch(id: String) {
        recentSearchesRepository.saveToRecentSearches(id: id)
    }
    
    //MARK: - Private methods
    
    private func getRecentSearchesModels(completion: @escaping ([SearchResult]) -> Void) {
        
        guard !recentSearchesRepository.isRecentSearchesEmpty else { return completion([]) }
        
        networkingService.getDataFor(IDs: recentSearchesRepository.recentSearches) { result in
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
                
                let recentSearches = self.recentSearchesRepository.recentSearches
                let sortedModels = recentSearchesModels.sorted(byList: recentSearches)
                
                completion(sortedModels)
                
            case .failure(let error):
                self.errorsState.value = .error(error)
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
                self.errorsState.value = .error(error)
            }
        }
    }
}

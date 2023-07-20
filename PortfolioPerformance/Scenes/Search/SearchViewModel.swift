import Foundation

final class SearchScreenViewModel {
    
    // MARK: - Dependencies
    
    private let networkingService: NetworkingServiceProtocol
    private let recentSearchesRepository: RecentSearchesRepositoryProtocol
    
    //MARK: - Observables
    
    var recentSearchesModels: ObservableObject<[SearchResult]> = ObservableObject(value: [])
    var trendingCoinsModels: ObservableObject<[SearchResult]> = ObservableObject(value: [])
    var searchResultCellModels: ObservableObject<[SearchResult]> = ObservableObject(value: [])
    var errorMessage: ObservableObject<ErrorState> = ObservableObject(value: .noErrors)
    
    //MARK: - Init
    
    init(networkingService: NetworkingServiceProtocol, recentSearchesRepository: RecentSearchesRepositoryProtocol) {
        self.networkingService = networkingService
        self.recentSearchesRepository = recentSearchesRepository
        fetchData()
    }
    
    convenience init() {
        self.init(networkingService: DefaultNetworkingService(), recentSearchesRepository: DefaultRecentSearchesRepository())
    }
    
    //MARK: - Interface
    
    var isRecentSearchesEmpty: Bool {
        recentSearchesRepository.isRecentSearchesEmpty
    }
    
    func updateRecentSearches() {
        isRecentSearchesEmpty
        ? recentSearchesModels = ObservableObject(value: [])
        : getRecentSearchesModels { models in
            self.recentSearchesModels.value = models.reversed()
        }
    }
    
    func updateSearchResults(query: String) {
        
        networkingService.searchWith(query: query) { result in
            switch result {
            case.success(let response):
                self.searchResultCellModels.value = Array(response.coins.prefix(6)).sortedByPrefix(query)
                
            case .failure(let error):
                self.errorMessage.value = .error(error)
            }
        }
    }
    
    func clearSearchModels() {
        searchResultCellModels.value = []
    }
    
    func clearRecentSearches() {
        recentSearchesModels.value = []
        recentSearchesRepository.clearRecentSearches()
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
                self.errorMessage.value = .error(error)
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
                self.errorMessage.value = .error(error)
            }
        }
    }
    
    private func fetchData() {
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
}

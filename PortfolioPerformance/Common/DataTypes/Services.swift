class Services {
    let watchlistStore: DefaultWatchlistStore
    let recentSearchesService: DefaultRecentSearchesRepository
    
    init(watchlistStore: DefaultWatchlistStore, recentSearchesService: DefaultRecentSearchesRepository) {
        self.watchlistStore = watchlistStore
        self.recentSearchesService = recentSearchesService
    }
}

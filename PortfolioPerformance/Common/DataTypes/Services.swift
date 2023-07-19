class Services {
    let watchlistStore: WatchlistStore
    let recentSearchesService: DefaultRecentSearchesRepository
    
    init(watchlistStore: WatchlistStore, recentSearchesService: DefaultRecentSearchesRepository) {
        self.watchlistStore = watchlistStore
        self.recentSearchesService = recentSearchesService
    }
}

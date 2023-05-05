class Services {
    let watchlistStore: WatchlistStore
    let recentSearchesService: RecentSearchesStore
    
    init(watchlistStore: WatchlistStore, recentSearchesService: RecentSearchesStore) {
        self.watchlistStore = watchlistStore
        self.recentSearchesService = recentSearchesService
    }
}

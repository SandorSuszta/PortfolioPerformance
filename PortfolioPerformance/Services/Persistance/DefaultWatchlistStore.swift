import Foundation

protocol WatchlistRepository {
    var watchlist: [String] { get }
    
    func save(id: String)
    func delete(id: String)
    func reorderWatchlist(sourceIndex: Int, destinationIndex: Int)
}

struct DefaultWatchlistStore: WatchlistRepository {
    
    //MARK: - Properties
    
    private let watchlistKey = PersistantDataType.watchlist.dictionaryKey
    private let defaults = UserDefaults.standard
    
    //MARK: - Methods
    
    var watchlist: [String] {
        defaults.stringArray(forKey: watchlistKey) ?? []
    }
    
    func save(id: String) {
        var currentIDs = defaults.stringArray(forKey: watchlistKey) ?? []
        
        //Make sure recent ID is the last in the list
        if let indexOfID = currentIDs.firstIndex(of: id) {
            currentIDs.remove(at: indexOfID)
        }
        currentIDs.append(id)
        defaults.set(currentIDs, forKey: watchlistKey)
    }
    
    func delete(id: String) {
        var currentWatchlist = defaults.stringArray(forKey: watchlistKey)
        
        currentWatchlist?.removeAll { $0 == id }
        defaults.set(currentWatchlist, forKey: watchlistKey)
    }
    
    func reorderWatchlist(sourceIndex: Int, destinationIndex: Int) {
        guard var currentWatchlist = defaults.stringArray(forKey: watchlistKey) else { return }
        
        let idToMove = currentWatchlist[sourceIndex]
        currentWatchlist.remove(at: sourceIndex)
        currentWatchlist.insert(idToMove, at: destinationIndex)
        
        defaults.set(currentWatchlist, forKey: watchlistKey)
    }
}

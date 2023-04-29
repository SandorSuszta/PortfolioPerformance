import Foundation

protocol WatchlistStoreProtocol {
    func getWatchlist() -> [String]
    func saveToWatchlist(id: String)
    func deleteFromWatchlist(id: String)
    func reorderWatchlist(sourceIndex: Int, destinationIndex: Int)
}

struct WatchlistStore: WatchlistStoreProtocol {
    
    //MARK: - Properties
    
    private let watchlistKey = PersistantDataType.watchlist.rawValue
    private let defaults = UserDefaults.standard
    
    
    //MARK: - Methods
    
    func getWatchlist() -> [String] {
        defaults.stringArray(forKey: watchlistKey) ?? []
    }
    
    func saveToWatchlist(id: String) {
        var currentIDs = defaults.stringArray(forKey: watchlistKey) ?? []
        
        //Make sure recent ID is the last in the list
        if let indexOfID = currentIDs.firstIndex(of: id) {
            currentIDs.remove(at: indexOfID)
        }
        currentIDs.append(id)
        defaults.set(currentIDs, forKey: watchlistKey)
    }
    
    func deleteFromWatchlist(id: String) {
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

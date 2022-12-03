import Foundation

struct UserDefaultsManager {
    
    static let shared = UserDefaultsManager()
    
    private init() {}
    
    private let defaults = UserDefaults.standard
    
    var watchlistIDs: [String] {
        defaults.stringArray(forKey: watchlistKey) ?? []
    }
    
    var recentSearchesIDs: [String] {
        defaults.stringArray(forKey: recentSearchesKey) ?? []
    }
    
    let watchlistKey = "watchlist"
    
    let recentSearchesKey = "recentSearch"
    
    func saveToDefaults(ID: String, forKey key: String) {
        var currentIDs = defaults.stringArray(forKey: key) ?? []
        
        //Make sure recent ID is the last in the list
        if let indexOfID = currentIDs.firstIndex(of: ID) {
            currentIDs.remove(at: indexOfID)
        }
        currentIDs.append(ID)
        defaults.set(currentIDs, forKey: key)
    }
    
    func deleteFromDefaults(ID: String, forKey key: String) {
        var currentIDs = watchlistIDs
        currentIDs.removeAll { $0 == ID }
        defaults.set(currentIDs, forKey: key)
    }
    
    func isInWatchlist(id: String) -> Bool {
        watchlistIDs.contains(id)
    }
    
    func clearRecentSearchesIDs() {
        defaults.set([], forKey: recentSearchesKey)
    }
    
    func clearWatchlist() {
        defaults.set([], forKey: watchlistKey)
    }
}

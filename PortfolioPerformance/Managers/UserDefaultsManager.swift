import Foundation

enum DefaultsKeys: String {
    case watchlist = "watchlist"
    case recentSearches = "recentSearch"
    case recentTransactions = "recentTransactions"
}

struct UserDefaultsManager {
    
    static let shared = UserDefaultsManager()
    
    private init() {}
    
    private let defaults = UserDefaults.standard
    
    var watchlistIDs: [String] {
        defaults.stringArray(forKey: DefaultsKeys.watchlist.rawValue) ?? []
    }
    
    var recentSearchesIDs: [String] {
        defaults.stringArray(forKey: DefaultsKeys.recentSearches.rawValue) ?? []
    }
    
    var recentTransactionsIDs: [String] {
        defaults.stringArray(forKey: DefaultsKeys.recentTransactions.rawValue ) ?? []
    }
    
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
        defaults.set([], forKey: DefaultsKeys.recentSearches.rawValue)
    }
}

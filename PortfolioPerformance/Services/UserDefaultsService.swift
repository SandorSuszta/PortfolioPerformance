import Foundation

enum UserDefaultDictionary: String {
    case watchlist = "watchlist"
    case recentSearches = "recentSearch"
}

struct UserDefaultsService {
    
    static let shared = UserDefaultsService()
    
    private init() {}
    
    private let defaults = UserDefaults.standard
    
    var watchlistIDs: [String] {
        defaults.stringArray(forKey: UserDefaultDictionary.watchlist.rawValue) ?? []
    }
    
    var recentSearchesIDs: [String] {
        defaults.stringArray(forKey: UserDefaultDictionary.recentSearches.rawValue) ?? []
    }
    
    func saveTo(_ dictionary: UserDefaultDictionary, ID: String) {
        let key = dictionary.rawValue
        
        var currentIDs = defaults.stringArray(forKey: key) ?? []
        
        //Make sure recent ID is the last in the list
        if let indexOfID = currentIDs.firstIndex(of: ID) {
            currentIDs.remove(at: indexOfID)
        }
        currentIDs.append(ID)
        defaults.set(currentIDs, forKey: key)
    }
    
    func deleteFrom(_ dictionary: UserDefaultDictionary, ID: String) {
        let key = dictionary.rawValue
        
        var currentIDs = watchlistIDs
        currentIDs.removeAll { $0 == ID }
        defaults.set(currentIDs, forKey: key)
    }
    
    func isInWatchlist(id: String) -> Bool {
        watchlistIDs.contains(id)
    }
    
    func clearRecentSearchesIDs() {
        defaults.set([], forKey: UserDefaultDictionary.recentSearches.rawValue)
    }
    
    func replaceWatchlist(with reorderedWatchlist: [String]) {
        defaults.set(reorderedWatchlist, forKey: UserDefaultDictionary.watchlist.rawValue)
    }
}

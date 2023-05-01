import Foundation

protocol RecentSearchesProtocol {
    func getRecentSearches() -> [String]
    func saveToRecentSearches(id: String)
    func clearRecentSearches()
}

struct RecentSearchesStore: RecentSearchesProtocol {
    
    //MARK: - Properties
    
    private let recentSearchesKey = PersistantDataType.recentSearches.rawValue
    private let defaults = UserDefaults.standard
    
    //MARK: - Methods
    
    func getRecentSearches() -> [String] {
        defaults.stringArray(forKey: recentSearchesKey) ?? []
    }
    
    func saveToRecentSearches(id: String) {
        var currentRecentSearches = defaults.stringArray(forKey: recentSearchesKey) ?? []
        
        //Make sure recent ID is the firest in the list
        if let indexOfID = currentRecentSearches.firstIndex(of: id) {
            currentRecentSearches.remove(at: indexOfID)
        }
        currentRecentSearches.insert(id, at: 0)
        defaults.set(currentRecentSearches, forKey: recentSearchesKey)
    }
    
    func clearRecentSearches() {
        defaults.set([], forKey: recentSearchesKey)
    }
}

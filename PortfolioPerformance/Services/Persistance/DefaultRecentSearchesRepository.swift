import Foundation

protocol RecentSearchesRepositoryProtocol {
    var recentSearches: [String] { get }
    var isRecentSearchesEmpty: Bool { get }
    
    func saveToRecentSearches(id: String)
    func clearRecentSearches()
}

struct DefaultRecentSearchesRepository: RecentSearchesRepositoryProtocol {
    
    //MARK: - Properties
    
    private let recentSearchesKey = PersistantDataType.recentSearches.dictionaryKey
    private let defaults = UserDefaults.standard
    
    //MARK: - API
    
    var recentSearches: [String] {
        defaults.stringArray(forKey: recentSearchesKey) ?? []
    }
    
    var isRecentSearchesEmpty: Bool {
        guard let recentSearches = defaults.stringArray(forKey: recentSearchesKey)
        else { return false }
        
        return recentSearches.isEmpty
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

import Foundation

//struct UserDefaultsService {
//    
//    static let shared = UserDefaultsService()
//    
//    private init() {}
//    
//    private let defaults = UserDefaults.standard
//    
//    var watchlistIDs: [String] {
//        defaults.stringArray(forKey: PersistantDataType.watchlist.dictionaryKey) ?? []
//    }
//    
//    var recentSearchesIDs: [String] {
//        defaults.stringArray(forKey: PersistantDataType.recentSearches.dictionaryKey) ?? []
//    }
//    
//    func saveTo(_ dictionary: PersistantDataType, ID: String) {
//        let key = dictionary.rawValue
//        
//        var currentIDs = defaults.stringArray(forKey: key) ?? []
//        
//        //Make sure recent ID is the last in the list
//        if let indexOfID = currentIDs.firstIndex(of: ID) {
//            currentIDs.remove(at: indexOfID)
//        }
//        currentIDs.append(ID)
//        defaults.set(currentIDs, forKey: key)
//    }
//    
//    func deleteFrom(_ dictionary: PersistantDataType, ID: String) {
//        let key = dictionary.rawValue
//        
//        var currentIDs = watchlistIDs
//        currentIDs.removeAll { $0 == ID }
//        defaults.set(currentIDs, forKey: key)
//    }
//    
//    func isInWatchlist(id: String) -> Bool {
//        watchlistIDs.contains(id)
//    }
//    
//    func clearRecentSearchesIDs() {
//        defaults.set([], forKey: PersistantDataType.recentSearches.dictionaryKey)
//    }
//    
//    func reorderWatchlist(moveFrom sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
//        guard let watchlist = defaults.stringArray(forKey: PersistantDataType.watchlist.dictionaryKey) else { return }
//                                                   
//        let ID = watchlist[sourceIndexPath.row]
//        var reorderedWatchlist = watchlist
//        reorderedWatchlist.remove(at: sourceIndexPath.row)
//        reorderedWatchlist.insert(ID, at: destinationIndexPath.row)
//        
//        defaults.set(reorderedWatchlist, forKey: PersistantDataType.watchlist.dictionaryKey)
//    }
//}

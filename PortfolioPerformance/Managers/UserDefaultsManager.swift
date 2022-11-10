import UIKit
import CoreData

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
//    static let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
//
//    static func saveUpdates () {
//        do {
//            try  context.save()
//        } catch {
//            print("Error saving Transaction")
//        }
//    }
//
//    static func updateHoldingsWithNewTransaction (transaction: Transaction) {
//        let holdings = WatchlistManager.loadHoldings()
//        switch transaction.type {
//        case "buy":
//
//            if let holdingToUpdate = holdings.first(where: {
//                $0.symbol == transaction.boughtCurrency
//            }) {
//                holdingToUpdate.ammount += transaction.ammount
//                holdingToUpdate.totalCostBasis += transaction.price * transaction.ammount
//            } else {
//                let newHolding = HoldingModel(context: WatchlistManager.context)
//                newHolding.symbol = transaction.boughtCurrency
//                newHolding.ammount = transaction.ammount
//                newHolding.totalCostBasis = transaction.price * transaction.ammount
//            }
//
//        default:
//            fatalError()
//        }
//        WatchlistManager.saveUpdates()
//    }
//
//    static func updateHoldingsWithDeletedTransaction (transaction: Transaction) {
//        let holdings = WatchlistManager.loadHoldings()
//        switch transaction.type {
//        case "buy":
//            if let holdingToUpdate = holdings.first(where: {
//                $0.symbol == transaction.boughtCurrency
//            }) {
//                holdingToUpdate.ammount -= transaction.ammount
//                holdingToUpdate.totalCostBasis -= transaction.price * transaction.ammount
//            } else {
//                fatalError()
//            }
//
//        default:
//            fatalError()
//        }
//        WatchlistManager.saveUpdates()
//    }
//    static func loadTransactions() -> [Transaction]{
//
//        var transactions: [Transaction] = []
//
//        let request: NSFetchRequest<Transaction> = Transaction.fetchRequest()
//
//        do {
//            transactions = try context.fetch(request)
//        } catch {
//            print("error fetching data")
//        }
//        return transactions
//    }
//
//    static func loadHoldings(with predicate: NSPredicate? = nil) -> [HoldingModel] {
//
//        var holdings: [HoldingModel] = []
//
//        let request: NSFetchRequest<HoldingModel> = HoldingModel.fetchRequest()
//        request.predicate = predicate
//
//        do {
//            holdings = try context.fetch(request)
//        } catch {
//            print("error fetching data")
//        }
//        return holdings
//    }
//
//    //Delete holding if user deletes all transactions
//    static func deleteHolding (symbol: String) {
//        guard let holdingToDelete = loadHoldings(with: NSPredicate(format: "symbol == %@", symbol)).first else { fatalError() }
//
//        WatchlistManager.context.delete(holdingToDelete)
//        WatchlistManager.saveUpdates()
//    }
}

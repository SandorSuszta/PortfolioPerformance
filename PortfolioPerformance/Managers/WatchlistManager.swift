import UIKit
import CoreData

struct WatchlistManager {
    
    static let shared = WatchlistManager()
    
    private init() {}
    
    public var watchlistIDs: [String] {
        defaults.stringArray(forKey: watchlistKey) ?? []
    }
    
    private let defaults = UserDefaults.standard
    
    private let watchlistKey = "watchlist"
    
    public func saveToWatchlist(ID: String) {
        var currentWatchlist = watchlistIDs
        currentWatchlist.append(ID)
        defaults.set(currentWatchlist, forKey: watchlistKey)
    }
    
    public func deleteFromWatchlist(ID: String) {
        var currentWatchlist = watchlistIDs
        currentWatchlist.removeAll { $0 == ID }
        defaults.set(currentWatchlist, forKey: watchlistKey)
    }
    
    public func isInWatchlist(id: String) -> Bool {
        watchlistIDs.contains(id)
    }
    
    
    static let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    static func saveUpdates () {
        do {
            try  context.save()
        } catch {
            print("Error saving Transaction")
        }
    }
    
    static func updateHoldingsWithNewTransaction (transaction: Transaction) {
        let holdings = WatchlistManager.loadHoldings()
        switch transaction.type {
        case "buy":
            
            if let holdingToUpdate = holdings.first(where: {
                $0.symbol == transaction.boughtCurrency
            }) {
                holdingToUpdate.ammount += transaction.ammount
                holdingToUpdate.totalCostBasis += transaction.price * transaction.ammount
            } else {
                let newHolding = HoldingModel(context: WatchlistManager.context)
                newHolding.symbol = transaction.boughtCurrency
                newHolding.ammount = transaction.ammount
                newHolding.totalCostBasis = transaction.price * transaction.ammount
            }

        default:
            fatalError()
        }
        WatchlistManager.saveUpdates()
    }
    
    static func updateHoldingsWithDeletedTransaction (transaction: Transaction) {
        let holdings = WatchlistManager.loadHoldings()
        switch transaction.type {
        case "buy":
            if let holdingToUpdate = holdings.first(where: {
                $0.symbol == transaction.boughtCurrency
            }) {
                holdingToUpdate.ammount -= transaction.ammount
                holdingToUpdate.totalCostBasis -= transaction.price * transaction.ammount
            } else {
                fatalError()
            }
            
        default:
            fatalError()
        }
        WatchlistManager.saveUpdates()
    }
    static func loadTransactions() -> [Transaction]{
        
        var transactions: [Transaction] = []
        
        let request: NSFetchRequest<Transaction> = Transaction.fetchRequest()
        
        do {
            transactions = try context.fetch(request)
        } catch {
            print("error fetching data")
        }
        return transactions
    }
    
    static func loadHoldings(with predicate: NSPredicate? = nil) -> [HoldingModel] {
        
        var holdings: [HoldingModel] = []
        
        let request: NSFetchRequest<HoldingModel> = HoldingModel.fetchRequest()
        request.predicate = predicate
        
        do {
            holdings = try context.fetch(request)
        } catch {
            print("error fetching data")
        }
        return holdings
    }
    
    //Delete holding if user deletes all transactions
    static func deleteHolding (symbol: String) {
        guard let holdingToDelete = loadHoldings(with: NSPredicate(format: "symbol == %@", symbol)).first else { fatalError() }
        
        WatchlistManager.context.delete(holdingToDelete)
        WatchlistManager.saveUpdates()
    }
}

//
//  PersistanceManager.swift
//  PortfolioPerformance
//
//  Created by Nataliia Shusta on 01/03/2022.
//

import UIKit
import CoreData

struct PersistanceManager {
    
   static let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    static func saveTransaction () {
        
        do {
            try  context.save()
        } catch {
            print("Error saving Transaction")
        }
        
    }
    
    static func loadTransactions() {
        
        var transactions: [NSManagedObject] = []
        
        let request: NSFetchRequest<Transaction> = Transaction.fetchRequest()
        
        do {
            transactions = try context.fetch(request)
        } catch {
            print("error fetching data")
        }
        
        print(transactions)
    }
    
    
    
}

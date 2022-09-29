//
//  TransactionHistoryViewController.swift
//  PortfolioPerformance
//
//  Created by Nataliia Shusta on 02/03/2022.
//

import UIKit
import CoreData

class TransactionHistoryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var transactionHistoryTableView: UITableView!
    

    private let cellId = "transactionHistoryCell"
    
    var transactionHistory: [Transaction] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        transactionHistory = WatchlistManager.loadTransactions()
        
        transactionHistoryTableView.dataSource = self
        transactionHistoryTableView.delegate = self
       
        registerTableViewCells()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        transactionHistory = WatchlistManager.loadTransactions()
        transactionHistoryTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        transactionHistory.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let transactionType = transactionHistory[indexPath.row].type
        
        switch transactionType {
            
        case "sell":
            let cell = transactionHistoryTableView.dequeueReusableCell(withIdentifier: TransactionHistorySellTableViewCell.identifier, for: indexPath) as! TransactionHistorySellTableViewCell
            let configuredCell = cell.configureSellCell(with: transactionHistory[indexPath.row])
            return  configuredCell
            
        case "buy":
            let cell = transactionHistoryTableView.dequeueReusableCell(withIdentifier: TransactionHistoryBuyTableViewCell.identifier, for: indexPath) as! TransactionHistoryBuyTableViewCell
            let configuredCell = cell.configureBuyCell(with: transactionHistory[indexPath.row])
            return  configuredCell
            
        case "convert":
            let cell = transactionHistoryTableView.dequeueReusableCell(withIdentifier: TransactionHistoryConvertTableViewCell.identifier, for: indexPath) as! TransactionHistoryConvertTableViewCell
            let configuredCell = cell.configureConvertCell(with: transactionHistory[indexPath.row])
            return configuredCell
            
        case "transfer":
            let cell = transactionHistoryTableView.dequeueReusableCell(withIdentifier: TransactionHistoryTransferTableViewCell.identifier, for: indexPath) as! TransactionHistoryTransferTableViewCell
            let configuredCell = TransactionHistoryTransferTableViewCell.configureTransferCell(cell: cell, transaction: transactionHistory[indexPath.row])
            return  configuredCell
            
        default:
            fatalError()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let transactionType = transactionHistory[indexPath.row].type
        var size: CGFloat
        switch transactionType {
        case "buy":
            size = 175
        case "sell":
            size = 175
        case "convert":
            size = 250
        case "transfer":
            size = 150
        default:
            fatalError()
        }
        return size
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            let symbol = transactionHistory[indexPath.row].boughtCurrency
            
            WatchlistManager.updateHoldingsWithDeletedTransaction(
                transaction: transactionHistory[indexPath.row]
            )
            
            WatchlistManager.context.delete(
                transactionHistory[indexPath.row]
            )
            
            transactionHistory.remove(at: indexPath.row)
            
            WatchlistManager.saveUpdates()
            
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            //Delete holding if user deletes all transactions
            if !transactionHistory.contains(where: { $0.boughtCurrency == symbol
            }) {
                WatchlistManager.deleteHolding(symbol: symbol ?? "")
            }
        }
    }
    
   private func registerTableViewCells() {

       self.transactionHistoryTableView.register(TransactionHistorySellTableViewCell.nib(), forCellReuseIdentifier: TransactionHistorySellTableViewCell.identifier)
       
       self.transactionHistoryTableView.register(TransactionHistoryBuyTableViewCell.nib(), forCellReuseIdentifier: TransactionHistoryBuyTableViewCell.identifier)
       
       self.transactionHistoryTableView.register(TransactionHistoryConvertTableViewCell.nib(), forCellReuseIdentifier: TransactionHistoryConvertTableViewCell.identifier)
       
       let transferCell = UINib(nibName: TransactionHistoryTransferTableViewCell.identifier, bundle: nil)
       self.transactionHistoryTableView.register(transferCell, forCellReuseIdentifier: TransactionHistoryTransferTableViewCell.identifier)
    }
    
   
}

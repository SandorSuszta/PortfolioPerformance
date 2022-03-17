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
        
        transactionHistory = PersistanceManager.loadTransactions()
        
        transactionHistoryTableView.dataSource = self
        transactionHistoryTableView.delegate = self
       
        registerTableViewCells()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        transactionHistory = PersistanceManager.loadTransactions()
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
            let configuredCell = TransactionHistorySellTableViewCell.configureSellCell(cell: cell, transaction: transactionHistory[indexPath.row])
            return  configuredCell
            
        case "buy":
            let cell = transactionHistoryTableView.dequeueReusableCell(withIdentifier: TransactionHistoryBuyTableViewCell.identifier, for: indexPath) as! TransactionHistoryBuyTableViewCell
            let configuredCell = TransactionHistoryBuyTableViewCell.configureBuyCell(cell: cell, transaction: transactionHistory[indexPath.row])
            return  configuredCell
            
        default:
            fatalError()
        }
       
    }
    
   private func registerTableViewCells() {
       let sellCell = UINib(nibName: TransactionHistorySellTableViewCell.identifier, bundle: nil)
       self.transactionHistoryTableView.register(sellCell, forCellReuseIdentifier: TransactionHistorySellTableViewCell.identifier)
       let buyCell = UINib(nibName: TransactionHistoryBuyTableViewCell.identifier, bundle: nil)
       self.transactionHistoryTableView.register(buyCell, forCellReuseIdentifier: TransactionHistoryBuyTableViewCell.identifier)
    }
    
   
}

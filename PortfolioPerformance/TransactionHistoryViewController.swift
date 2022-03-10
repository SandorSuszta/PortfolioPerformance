//
//  TransactionHistoryViewController.swift
//  PortfolioPerformance
//
//  Created by Nataliia Shusta on 02/03/2022.
//

import UIKit

class TransactionHistoryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var transactionHistoryTableView: UITableView!
    

    private let cellId = "transactionHistoryCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        transactionHistoryTableView.dataSource = self
        transactionHistoryTableView.delegate = self
       
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        42
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = transactionHistoryTableView.dequeueReusableCell(withIdentifier: self.cellId, for: indexPath)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        185
    }
}

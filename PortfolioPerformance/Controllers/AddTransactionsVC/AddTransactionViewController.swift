//
//  AddTransactionViewController.swift
//  PortfolioPerformance
//
//  Created by Nataliia Shusta on 16/02/2022.
//

import UIKit

class AddTransactionViewController: UIViewController {
    
    @IBOutlet weak var sellView: UIView!
    @IBOutlet weak var buyView: UIView!
    @IBOutlet weak var transferView: UIView!
    
    @IBAction func transactionTypeSegment(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            sellView.alpha = 0
            buyView.alpha = 1
            transferView.alpha = 0
        } else if sender.selectedSegmentIndex == 1 {
            sellView.alpha = 1
            buyView.alpha = 0
            transferView.alpha = 0
        } else if sender.selectedSegmentIndex == 2 {
            sellView.alpha = 0
            buyView.alpha = 0
            transferView.alpha = 1
        }
    }
    
    @IBOutlet weak var tradingPairButton: UIButton!
    
    private let segueID = "addTransactionToTradingPairs"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sellView.alpha = 0
        transferView.alpha = 0  
        
    }

}


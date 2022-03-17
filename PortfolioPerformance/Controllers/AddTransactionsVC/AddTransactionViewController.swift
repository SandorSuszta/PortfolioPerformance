//
//  AddTransactionViewController.swift
//  PortfolioPerformance
//
//  Created by Nataliia Shusta on 16/02/2022.
//

import UIKit

class AddTransactionViewController: UIViewController {
    
    @IBOutlet weak var symbolLabel: UILabel!
    @IBOutlet weak var selectTradingPairButton: UIButton!
    @IBOutlet weak var logo: UIImageView!
    
    @IBOutlet weak var sellView: UIView!
    @IBOutlet weak var buyView: UIView!
    @IBOutlet weak var transferView: UIView!
    
    static var selectedCoin: CoinModel?
    static var tradingPairCoinSymbol: String = "USDT"
    
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
        
        updateUI()
        
        sellView.alpha = 0
        transferView.alpha = 0
        
    }
    
    func updateUI() {
        let selectedCoin = AddTransactionViewController.selectedCoin
        
        self.navigationItem.title = selectedCoin?.name
        self.symbolLabel.text = selectedCoin?.symbol.uppercased()
        self.tradingPairButton.setTitle(
            "\(selectedCoin?.symbol.uppercased() ?? "") / " + AddTransactionViewController.tradingPairCoinSymbol,
            for: .normal) 
        // Set image
        if let imageData = selectedCoin?.imageData {
            self.logo.image = UIImage(data: imageData)
        }
    }
}

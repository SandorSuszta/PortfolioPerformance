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
    @IBOutlet weak var logoView: UIView!
    @IBOutlet weak var logo: UIImageView!
    
    @IBOutlet weak var sellView: UIView!
    @IBOutlet weak var buyView: UIView!
    @IBOutlet weak var transferView: UIView!
    @IBOutlet weak var convertView: UIView!
    
    
    static var selectedCoin: CoinModel?
    static var tradingPairCoinSymbol: String = "USDT"
    
    @IBAction func transactionTypeSegment(_ sender: UISegmentedControl) {
        
        switch sender.selectedSegmentIndex {
        case 0:
            sellView.alpha = 0
            buyView.alpha = 1
            transferView.alpha = 0
            convertView.alpha = 0
        case 1:
            sellView.alpha = 1
            buyView.alpha = 0
            transferView.alpha = 0
            convertView.alpha = 0
        case 2:
            sellView.alpha = 0
            buyView.alpha = 0
            transferView.alpha = 0
            convertView.alpha = 1
        case 3:
            sellView.alpha = 0
            buyView.alpha = 0
            transferView.alpha = 1
            convertView.alpha = 0
        default:
            fatalError()
        }
    }
    
    @IBOutlet weak var tradingPairButton: UIButton!
    
    private let segueID = "addTransactionToTradingPairs"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateUI()
        logoView.configureWithShadow()
        
        sellView.alpha = 0
        transferView.alpha = 0
        convertView.alpha = 0

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


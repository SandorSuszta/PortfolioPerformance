//
//  TransactionHistoryBuyTableViewCell.swift
//  PortfolioPerformance
//
//  Created by Nataliia Shusta on 17/03/2022.
//

import UIKit

class TransactionHistoryBuyTableViewCell: UITableViewCell {
    
    @IBOutlet weak var logo: UIImageView!
    @IBOutlet weak var transactionView: UIView!
    @IBOutlet weak var transactionType: UILabel!
    @IBOutlet weak var transactionPairLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var profitOrLossLabel: UILabel!
    @IBOutlet weak var percentageLabel: UILabel!
    @IBOutlet weak var ammountLabel: UILabel!
    @IBOutlet weak var currentValueLabel: UILabel!
    @IBOutlet weak var costLabel: UILabel!
    
    static let identifier = "TransactionHistoryBuyTableViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: TransactionHistoryBuyTableViewCell.identifier, bundle: nil)
    }
    
    func configureBuyCell(with transaction: Transaction) -> TransactionHistoryBuyTableViewCell {
        // Transaction type label
        self.transactionType.backgroundColor = UIColor .nephritis.withAlphaComponent(0.3)
        self.transactionType.text = "Buy"
        
        //Transaction pair label
        self.transactionPairLabel.text = "\(transaction.boughtCurrency?.uppercased() ?? "") / \(transaction.convertedCurrency ?? "")"
        
        // Date label
        if let date = transaction.dateAndTime {
            self.dateLabel.text = date.formatedString()
        }
        
        // Ammount label
        self.ammountLabel.text = String(transaction.ammount)
        
        // Price label
        self.priceLabel.text = transaction.price.string2f()
        
        //Cost label
        let cost = transaction.ammount * transaction.price
        self.costLabel.text = cost.string2f()
        
        //Value label
        var value = 0.0
        MarketData.shared.getMarketData()
        if let currentPrice = MarketData.shared.allCoinsArray.first(where:{ $0.symbol == transaction.boughtCurrency?.lowercased()
        })?.currentPrice {
            value = transaction.ammount * currentPrice
            self.currentValueLabel.text = value.string2f()
        }
        
        //ProfitOrLoss and Percentage labels
        let profitOrLoss = value - cost
        let percentage = profitOrLoss/cost * 100
        
        if profitOrLoss >= 0 {
            self.profitOrLossLabel.textColor = .nephritis
            self.percentageLabel.textColor = .nephritis
        } else {
            self.profitOrLossLabel.textColor = .pomergranate
            self.percentageLabel.textColor = .pomergranate
        }
        self.profitOrLossLabel.text =  profitOrLoss.string2f()
        self.percentageLabel.text = percentage.string2f() + " %"
        
        //Logo
        if let logoData = transaction.logo {
            self.logo.image = UIImage(data: logoData)
        }
        
        return self
    }
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        transactionType.layer.cornerRadius = 10
        transactionType.layer.masksToBounds = true
        transactionView.layer.cornerRadius = 10
        transactionView.layer.masksToBounds = true
        
    }
}

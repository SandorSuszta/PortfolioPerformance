//
//  TransactionHistoryConvertTableViewCell.swift
//  PortfolioPerformance
//
//  Created by Nataliia Shusta on 17/03/2022.
//

import UIKit

class TransactionHistoryConvertTableViewCell: UITableViewCell {
    
    @IBOutlet weak var logo: UIImageView!
    @IBOutlet weak var convertedCoinLogo: UIImageView!
    
    @IBOutlet weak var transactionView: UIView!
    @IBOutlet weak var transactionType: UILabel!
    @IBOutlet weak var transactionPair: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var ammount: UILabel!
    @IBOutlet weak var convertRatio: UILabel!
    @IBOutlet weak var percentage: UILabel!
    @IBOutlet weak var valueInUsd: UILabel!
    @IBOutlet weak var worthNow: UILabel!
    @IBOutlet weak var convertDelta: UILabel!
    @IBOutlet weak var convertedAmmount: UILabel!
    @IBOutlet weak var holdingPercentage: UILabel!
    @IBOutlet weak var profitOrLoss: UILabel!
    @IBOutlet weak var exitProfitOrLoss: UILabel!
    
    
    static let identifier = "TransactionHistoryConvertTableViewCell"
    
    static func nib() -> UINib {
        UINib(nibName: TransactionHistoryConvertTableViewCell.identifier, bundle: nil)
    }
    
    func configureConvertCell(with transaction: Transaction) -> TransactionHistoryConvertTableViewCell {
        
        // Transaction type label
        self.transactionType.backgroundColor = .orange.withAlphaComponent(0.3)
        self.transactionType.text = "Convert"
        
        //Transaction pair label
        self.transactionPair.text = "\(transaction.boughtCurrency ?? "") / \(transaction.convertedCurrency ?? "")"
        
        // Date label
        if let date = transaction.dateAndTime {
            self.dateLabel.text = Formatter.formatDate(from: date)
        }
        
        //Convert ratio label
        self.convertRatio.text = transaction.price.string2f()
        
        // Ammount label
        self.ammount.text = String(transaction.ammount)
        
        // Holding  percentage
        
        //Value in USD
        self.valueInUsd.text = transaction.convertedCoinWorthThen.string2f()
        
        //Worth now label
        var value = 0.0
        MarketData.getMarketData()
        if let currentPrice = MarketData.allCoinsArray.filter({$0.symbol == transaction.boughtCurrency?.lowercased()}).first?.currentPrice {
            value = transaction.ammount * currentPrice
            self.worthNow.text = value.string2f()
        }
        
        //ProfitOrLoss and Percentage labels
        let profitOrLoss = value - transaction.convertedCoinWorthThen
        let percentage = profitOrLoss/transaction.convertedCoinWorthThen * 100
        
        if profitOrLoss >= 0 {
            self.profitOrLoss.textColor = UIColor(named: MyColours.nephritis)
            self.percentage.textColor = UIColor(named: MyColours.nephritis)
        } else {
            self.profitOrLoss.textColor = UIColor(named: MyColours.pomergranate)
            self.percentage.textColor = UIColor(named: MyColours.pomergranate)
        }
        
        self.profitOrLoss.text = profitOrLoss.string2f()
        self.percentage.text = percentage.string2f() + " %"
        
        // Converted ammount label
        self.convertedAmmount.text = (transaction.ammount * transaction.price).string2f()
        
        //Logo
        if let logoData = transaction.logo {
            self.logo.image = UIImage(data: logoData)        }
        
        //Converted Coin Logo
        if let convertedLogoData = transaction.convertedCoinLogo {
            self.convertedCoinLogo.image = UIImage(data: convertedLogoData)
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

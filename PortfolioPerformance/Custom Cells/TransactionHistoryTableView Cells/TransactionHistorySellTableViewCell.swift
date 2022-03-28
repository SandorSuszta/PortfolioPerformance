//
//  TransactionHistoryBuyTableViewCell.swift
//  PortfolioPerformance
//
//  Created by Nataliia Shusta on 16/03/2022.
//

import UIKit

class TransactionHistorySellTableViewCell: UITableViewCell {

    @IBOutlet weak var logo: UIImageView!
    @IBOutlet weak var transactionView: UIView!
    @IBOutlet weak var transactionType: UILabel!
    @IBOutlet weak var transactionPairLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var profitOrLossLabel: UILabel!
    @IBOutlet weak var ammountLabel: UILabel!
    @IBOutlet weak var currentValueLabel: UILabel!
    
    static let identifier = "TransactionHistorySellTableViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: TransactionHistorySellTableViewCell.identifier, bundle: nil)
    }
    
    func configureSellCell(with transaction: Transaction) -> TransactionHistorySellTableViewCell {
        
        // Transaction type label
            self.transactionType.backgroundColor = UIColor.red.withAlphaComponent(0.3)
            self.transactionType.text = "Sell"
        
        //Transaction pair label
        self.transactionPairLabel.text = "\(transaction.boughtCurrency ?? "") / \(transaction.convertedCurrency ?? "")"
        
        // Date label
        if let date = transaction.dateAndTime {
            self.dateLabel.text = Formatter.formatDate(from: date)
        }
        
        // Ammount label
        self.ammountLabel.text = String(transaction.ammount)
        
        // Price label
        self.priceLabel.text = String(transaction.price)
        
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

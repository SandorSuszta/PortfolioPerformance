//
//  TransactionHistoryTransferTableViewCell.swift
//  PortfolioPerformance
//
//  Created by Nataliia Shusta on 17/03/2022.
//

import UIKit

class TransactionHistoryTransferTableViewCell: UITableViewCell {

    @IBOutlet weak var logo: UIImageView!
    @IBOutlet weak var transactionView: UIView!
    @IBOutlet weak var transactionTypeLabel: UILabel!
    @IBOutlet weak var transactionPairLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var sourceLabel: UILabel!
    @IBOutlet weak var valueNowLabel: UILabel!
    @IBOutlet weak var ammountLabel: UILabel!
    
    static let identifier = "TransactionHistoryTransferTableViewCell"
    
    static func configureTransferCell(cell: TransactionHistoryTransferTableViewCell , transaction: Transaction) -> TransactionHistoryTransferTableViewCell {
        
        // Transaction type label
        cell.transactionTypeLabel.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.3)
            cell.transactionTypeLabel.text = "Transfer"
      
        //Transaction pair label
        cell.transactionPairLabel.text = "\(transaction.boughtCurrency ?? "")"
        
        // Date label
        if let date = transaction.dateAndTime {
            cell.dateLabel.text = Formatter.formatDate(from: date)
        }
        
        // Ammount label
        cell.ammountLabel.text = String(transaction.ammount)
        
        //Value now label
        if let currentPrice = MarketData.allCoinsArray.filter ({
            $0.symbol == transaction.boughtCurrency?.lowercased()
        }).first?.currentPrice {
            let valueNow = transaction.ammount * currentPrice
            cell.valueNowLabel.text = String(format: "%.2f", valueNow)
        }
        
        //Source label
        cell.sourceLabel.text = transaction.transferType
        
        //Logo
        if let logoData = transaction.logo {
            cell.logo.image = UIImage(data: logoData)
        }
       
        return cell
    }
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        transactionTypeLabel.layer.cornerRadius = 10
        transactionTypeLabel.layer.masksToBounds = true
        transactionView.layer.cornerRadius = 10
        transactionView.layer.masksToBounds = true
        
    }
}

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
    
    static func configureBuyCell(cell: TransactionHistoryBuyTableViewCell , transaction: Transaction) -> TransactionHistoryBuyTableViewCell {
        
        // Transaction type label
        cell.transactionType.backgroundColor = UIColor(named: MyColours.nephritis)?.withAlphaComponent(0.3)
            cell.transactionType.text = "Buy"
      
        //Transaction pair label
        cell.transactionPairLabel.text = "\(transaction.boughtCurrency ?? "") / \(transaction.soldCurrency ?? "")"
        
        // Date label
        if let date = transaction.dateAndTime {
            cell.dateLabel.text = Formatter.formatDate(from: date)
        }
        
        // Ammount label
        cell.ammountLabel.text = String(transaction.ammount)
        
        // Price label
        cell.priceLabel.text = String(transaction.price)
        
        //Cost label
        let cost = transaction.ammount * transaction.price
        cell.costLabel.text = String(cost)
        
        //Value label
        var value = 0.0
        if let currentPrice = MarketData.allCoinsArray.filter({$0.symbol == transaction.boughtCurrency?.lowercased()}).first?.currentPrice {
            value = transaction.ammount * currentPrice
            cell.currentValueLabel.text = String(value)
        }
        
        //ProfitOrLoss and Percentage labels
        let profitOrLoss = value - cost
        let percentage = profitOrLoss/cost * 100
        
        if profitOrLoss >= 0 {
            cell.profitOrLossLabel.textColor = UIColor(named: MyColours.nephritis)
            cell.percentageLabel.textColor = UIColor(named: MyColours.nephritis)
        } else {
            cell.profitOrLossLabel.textColor = UIColor(named: MyColours.pomergranate)
            cell.percentageLabel.textColor = UIColor(named: MyColours.pomergranate)
        }
        cell.profitOrLossLabel.text = String(format: "%.2f", profitOrLoss)
        cell.percentageLabel.text = String(format: "%.2f", percentage) + " %"
        
        //Logo
        if let logoData = transaction.logoData {
            cell.logo.image = UIImage(data: logoData)
        }
       
        return cell
    }
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        transactionType.layer.cornerRadius = 10
        transactionType.layer.masksToBounds = true
        transactionView.layer.cornerRadius = 10
        transactionView.layer.masksToBounds = true
        
    }
}

//
//  TransactionHistoryTableViewCell.swift
//  PortfolioPerformance
//
//  Created by Nataliia Shusta on 02/03/2022.
//

import UIKit

class TransactionHistoryTableViewCell: UITableViewCell {
    
    @IBOutlet weak var transactionView: UIView!
    @IBOutlet weak var logo: UIImageView!
    
    @IBOutlet weak var transactionType: UILabel!
    @IBOutlet weak var transactionPairLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var profitOrLossLabel: UILabel!
    @IBOutlet weak var ammountLabel: UILabel!
    @IBOutlet weak var currentValueLabel: UILabel!
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        transactionType.layer.cornerRadius = 10
        transactionType.layer.masksToBounds = true
        transactionView.layer.cornerRadius = 10
        transactionView.layer.masksToBounds = true
        
        transactionView.layer.cornerRadius = 10
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0))
    }
    
}

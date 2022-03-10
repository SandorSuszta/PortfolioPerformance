//
//  TransactionHistoryTableViewCell.swift
//  PortfolioPerformance
//
//  Created by Nataliia Shusta on 02/03/2022.
//

import UIKit

class TransactionHistoryTableViewCell: UITableViewCell {
    
    @IBOutlet weak var transactionView: UIView!
    
    @IBOutlet weak var sellLabel: UILabel!
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        sellLabel.layer.cornerRadius = 10
        sellLabel.layer.masksToBounds = true
        
        transactionView.layer.cornerRadius = 10
        transactionView.layer.masksToBounds = true
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0))
    }
    
}

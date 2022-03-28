//
//  MarketTableViewCell.swift
//  PortfolioPerformance
//
//  Created by Nataliia Shusta on 09/02/2022.
//

import UIKit

class MarketTableViewCell: UITableViewCell {
    
    @IBOutlet weak var logoViewShadow: UIView!
    @IBOutlet weak var logoView: UIView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var symbol: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var change: UILabel!
    @IBOutlet weak var logo: UIImageView!
    
    static let cellIdentifier = "marketTableViewCell"
    
    // Increase spacing between cells
    override  func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0))
    }


}

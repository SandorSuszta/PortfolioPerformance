//
//  MarketTableViewCell.swift
//  PortfolioPerformance
//
//  Created by Nataliia Shusta on 09/02/2022.
//

import UIKit

class MarketTableViewCell: UITableViewCell {
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var symbol: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var change: UILabel!
    @IBOutlet weak var logo: UIImageView!
    
    static let cellIdentifier = "marketTableViewCell"

}

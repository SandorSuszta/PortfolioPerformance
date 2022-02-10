//
//  CoinDetailsViewController.swift
//  PortfolioPerformance
//
//  Created by Nataliia Shusta on 10/02/2022.
//

import UIKit

class CoinDetailsViewController: UIViewController {
    
    @IBOutlet weak var coinLogo: UIImageView!
    @IBOutlet weak var symbolLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var priceChangeLabel: UILabel!
    @IBOutlet weak var priceChangeInPercentageLabel: UILabel!
    
    public var coinModel:CoinModel? = nil


    override func viewDidLoad() {
        super.viewDidLoad()

        title = coinModel?.name
        
        symbolLabel.text = coinModel?.symbol.uppercased()
        
        priceLabel.text = "\(coinModel?.currentPrice ?? 0)"
        
        if coinModel?.priceChange24H ?? 0 < 0 {
            priceChangeLabel.text = String(format:"%.3f", coinModel?.priceChange24H ?? 0)
            priceChangeLabel.textColor = UIColor.red
            priceChangeInPercentageLabel.text = String(format:"(%.2f", coinModel?.priceChangePercentage24H ?? 0)+"%)"
            priceChangeInPercentageLabel.textColor = UIColor.red
        } else {
            priceChangeLabel.text = String(format:"+%.3f", coinModel?.priceChange24H ?? 0)
            priceChangeLabel.textColor = UIColor.green
            priceChangeInPercentageLabel.text = String(format: "(+%.2f", coinModel?.priceChangePercentage24H ?? 0)+"%)"
            priceChangeInPercentageLabel.textColor = UIColor.green
        }
    
        if let imageData = coinModel?.imageData {
            coinLogo.image = UIImage(data: imageData)
        }
    }

}

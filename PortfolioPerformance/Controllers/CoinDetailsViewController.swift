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
    @IBOutlet weak var coinLogoView: UIView!
    @IBOutlet weak var isFavouriteButton: UIBarButtonItem!
    
    @IBAction func isFavouriteButtonClicked(_ sender: Any) {
        
        guard let symbol = coinModel?.symbol else { return }
        
        if WatchlistViewController.watchlistCoins.contains(symbol)
        {
            WatchlistViewController.watchlistCoins.removeAll { $0 == symbol }
            isFavouriteButton.image = UIImage(named: "favourite")
        } else {
            WatchlistViewController.watchlistCoins.append(symbol)
            isFavouriteButton.image = UIImage(named: "favourite.fill")
        }
    }
    
    public var coinModel:CoinModel? = nil
    
    private var isFavourite: Bool {
        WatchlistViewController.watchlistCoins.contains(coinModel?.symbol ?? "")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        isFavouriteButton.image = isFavourite ? UIImage(named: "favourite.fill") : UIImage(named: "favourite")
        
        //view
        coinLogoView.layer.cornerRadius = 15
        
        coinLogoView.layer.shadowColor = UIColor.lightGray.cgColor
        coinLogoView.layer.shadowOffset = .zero
        coinLogoView.layer.shadowOpacity = 0.5
        coinLogoView.layer.shadowRadius = 5.0
        coinLogo.layer.cornerRadius = 15
        coinLogo.layer.masksToBounds = true
        
        title = coinModel?.name
        
        symbolLabel.text = coinModel?.symbol.uppercased()
        
        priceLabel.text = "\(coinModel?.currentPrice ?? 0)"
        
        if coinModel?.priceChange24H ?? 0 < 0 {
            priceChangeLabel.text = String(format:"%.3f", coinModel?.priceChange24H ?? 0)
            priceChangeLabel.textColor = UIColor.pomergranate
            priceChangeInPercentageLabel.text = String(format:"(%.2f", coinModel?.priceChangePercentage24H ?? 0)+"%)"
            priceChangeInPercentageLabel.textColor = UIColor.pomergranate
        } else {
            priceChangeLabel.text = String(format:"+%.3f", coinModel?.priceChange24H ?? 0)
            priceChangeLabel.textColor = UIColor.nephritis
            priceChangeInPercentageLabel.text = String(format: "(+%.2f", coinModel?.priceChangePercentage24H ?? 0)+"%)"
            priceChangeInPercentageLabel.textColor = UIColor.nephritis
        }
        
        if let imageData = coinModel?.imageData {
            coinLogo.image = UIImage(data: imageData)
        } else {
            if let url = URL(string: coinModel?.image ?? "") {
                let task = URLSession.shared.dataTask(with: url) { data, _, _ in
                    if let data = data {
//                            coin.imageData = data
                        DispatchQueue.main.async {
                            self.coinLogo.image = UIImage(data: data)
                        }
                    } else {
                        print("Error getting image")
                    }
                }
                task.resume()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        isFavouriteButton.image = isFavourite ? UIImage(named: "favourite.fill") : UIImage(named: "favourite")
    }
}

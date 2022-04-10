import UIKit

class MarketTableCell: UITableViewCell {
    
    @IBOutlet weak var logoViewShadow: UIView!
    @IBOutlet weak var logoView: UIView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var symbol: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var change: UILabel!
    @IBOutlet weak var logo: UIImageView!
    
    static let identifier = "MarketTableCell"
    
    static func nib() -> UINib {
        return UINib(nibName: MarketTableCell.identifier, bundle: nil)
        
    }
    
   func configureCell(with coin: CoinModel) -> MarketTableCell {
        
            
            self.name.text = coin.name
            
            self.symbol.text = coin.symbol.uppercased()
            
            self.price.text = "$\(coin.currentPrice ?? 0)"
            
            self.change.text =  (coin.priceChangePercentage24H ?? 0).string2f()
            + "%"
            self.change.textColor = coin.priceChangePercentage24H ?? 0 >= 0 ? UIColor(named: "Nephritis") : UIColor(named: "Pomergranate")
            
            self.contentView.backgroundColor = .clouds
            
            // Set image
            
            if let imageData = coin.imageData {
                self.logo.image = UIImage(data: imageData)
            } else {
                if let url = URL(string: coin.image) {
                    let task = URLSession.shared.dataTask(with: url) { data, _, _ in
                        if let data = data {
//                            coin.imageData = data
                            DispatchQueue.main.async {
                                self.logo.image = UIImage(data: data)
                            }
                        } else {
                            print("Error getting image")
                        }
                    }
                    task.resume()
                }
            }
            
            self.logoViewShadow.layer.cornerRadius = 15
            self.logoViewShadow.layer.shadowColor = UIColor.lightGray.cgColor
            self.logoViewShadow.layer.shadowOffset = .zero
            self.logoViewShadow.layer.shadowOpacity = 0.5
            self.logoViewShadow.layer.shadowRadius = 5.0
            
            self.logoView.layer.cornerRadius = 15
            self.logoView.layer.masksToBounds = true
            
            self.logo.layer.masksToBounds = true
            
            return self
        }
    }


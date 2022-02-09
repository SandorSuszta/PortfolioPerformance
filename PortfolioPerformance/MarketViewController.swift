//
//  ViewController.swift
//  PortfolioPerformance
//
//  Created by Nataliia Shusta on 09/02/2022.
//

import UIKit

class MarketViewController: UIViewController {
    
    private var tableViewArray = [CoinModel]()
    
    private var favourites = ["btc","eth","ada","sol"]
    
    @IBOutlet weak var marketTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        marketTableView.dataSource = self
        marketTableView.delegate = self
        
        loadMarketData()
        
    }
    
    private func loadMarketData() {
        APICaller.shared.getMarketData { result in
            switch result {
                
            case .success(let coinArray):
                self.tableViewArray = coinArray
                
                DispatchQueue.main.async {
                    self.marketTableView.reloadData()
                }
                
            case .failure(let error):
                print(error)
                
            }
        }
    }
}

extension MarketViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableViewArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = marketTableView.dequeueReusableCell(withIdentifier: "marketTableViewCell", for: indexPath) as! MarketTableViewCell
        cell.name.text = self.tableViewArray[indexPath.row].name
        cell.symbol.text = self.tableViewArray[indexPath.row].symbol.uppercased()
        cell.price.text = "$\(self.tableViewArray[indexPath.row].currentPrice ?? 0)"
        cell.change.text = "\(self.tableViewArray[indexPath.row].priceChangePercentage24H ?? 0)"
        cell.change.textColor = self.tableViewArray[indexPath.row].priceChangePercentage24H ?? 0 >= 0 ? UIColor.green : UIColor.red
        return  cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        60
    }
}



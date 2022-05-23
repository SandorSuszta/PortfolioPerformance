//
//  WatchlistViewController.swift
//  PortfolioPerformance
//
//  Created by Nataliia Shusta on 06/04/2022.
//

import UIKit

class WatchlistViewController: UIViewController {
    
    @IBOutlet weak var watchlistTableView: UITableView!
    
    static var watchlistCoins: [String] = ["ada","eth","btc"]
    
    var watchlistTableViewArray: [CoinModel] = []
    private var clickedIndexPath = IndexPath()
    private let segueID = "watchlistToCoinDetails"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        MarketData.getMarketData()
        
        watchlistTableView.dataSource = self
        watchlistTableView.delegate = self
        
        watchlistTableView.register(
            MarketTableViewCell.self,
            forCellReuseIdentifier: MarketTableViewCell.identifier
        )
        
        watchlistTableView.layer.cornerRadius = 15
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        watchlistTableViewArray = []
        getCoinModelsForWatchlist()
        watchlistTableView.reloadData()
    }
    
    private func getCoinModelsForWatchlist() {
        
        for coin in WatchlistViewController.watchlistCoins {
            if let coinModel = MarketData.allCoinsArray.filter({
                $0.symbol == coin
            }).first
            {
                watchlistTableViewArray.append(coinModel)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! CoinDetailsViewController
        destinationVC.coinModel = watchlistTableViewArray[clickedIndexPath.row]
    }
}

extension WatchlistViewController: UITableViewDataSource, UITableViewDelegate {
    
    //MARK: - Table View Data Source Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        WatchlistViewController.watchlistCoins.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = watchlistTableView.dequeueReusableCell(
            withIdentifier: MarketTableViewCell.identifier,
            for: indexPath
        ) as? MarketTableViewCell else {
            fatalError()
        }
        
        cell.configureCell(with: .init(
            model: watchlistTableViewArray[indexPath.row])
        )
        return cell
    }
    
    //MARK: - Table View Delegate Methods
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        MarketTableViewCell.prefferedHeight
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            WatchlistViewController.watchlistCoins.remove(at: indexPath.row)
            watchlistTableViewArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        clickedIndexPath = indexPath
        performSegue(withIdentifier: segueID, sender: self)
    }
    
}

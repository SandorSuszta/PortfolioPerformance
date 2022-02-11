//
//  ViewController.swift
//  PortfolioPerformance
//
//  Created by Nataliia Shusta on 09/02/2022.
//

import UIKit

class MarketViewController: UIViewController {
    static var favouritesArray = [String]()
    private var clickedIndexPath = IndexPath()
    private var tableViewArray = [CoinModel]()
    private let marketToCoinDetailsSegue = "marketToCoinDetails"
    
    @IBOutlet weak var marketTableView: UITableView!
    @IBAction func refreshClicked(_ sender: Any) {
        loadMarketData()
        marketTableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        marketTableView.dataSource = self
        marketTableView.delegate = self
        //marketTableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        
        loadMarketData()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        guard !tableViewArray.isEmpty else { return }
        
        let topIndex = IndexPath(row: 0, section: 0)
        marketTableView.scrollToRow(at: topIndex, at: .top, animated: false)

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! CoinDetailsViewController
        destinationVC.coinModel = tableViewArray[clickedIndexPath.row]
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
        
        return  configureCell(cell: cell, indexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        75
    }
    
    func  tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        clickedIndexPath = indexPath
        performSegue(withIdentifier: marketToCoinDetailsSegue, sender: self)
    }
    
    private func configureCell(cell: MarketTableViewCell, indexPath: IndexPath) -> MarketTableViewCell {
        
        cell.name.text = self.tableViewArray[indexPath.row].name
        
        cell.symbol.text = self.tableViewArray[indexPath.row].symbol.uppercased()
        
        cell.price.text = "$\(self.tableViewArray[indexPath.row].currentPrice ?? 0)"
        
        cell.change.text = String(format: "%.2f", self.tableViewArray[indexPath.row].priceChangePercentage24H ?? 0)+"%"
        cell.change.textColor = self.tableViewArray[indexPath.row].priceChangePercentage24H ?? 0 >= 0 ? UIColor.green : UIColor.red
        
        // Set image

        if let imageData = self.tableViewArray[indexPath.row].imageData {
            cell.logo.image = UIImage(data: imageData)
        } else {
            if let url = URL(string: tableViewArray[indexPath.row].image) {
                let task = URLSession.shared.dataTask(with: url) { data, _, _ in
                    if let data = data {
                        self.tableViewArray[indexPath.row].imageData = data
                        DispatchQueue.main.async {
                            cell.logo.image = UIImage(data: data)
                        }
                    } else {
                        print("Error getting image")
                    }
                }
                task.resume()
            }
        }
    
       
        cell.logoViewShadow.layer.cornerRadius = 15
        cell.logoViewShadow.layer.shadowColor = UIColor.lightGray.cgColor
        cell.logoViewShadow.layer.shadowOffset = .zero
        cell.logoViewShadow.layer.shadowOpacity = 0.5
        cell.logoViewShadow.layer.shadowRadius = 5.0
        
        cell.logoView.layer.cornerRadius = 15
        cell.logoView.layer.masksToBounds = true
        
        cell.logo.layer.masksToBounds = true
        
        
        
        return cell
    }
    
}



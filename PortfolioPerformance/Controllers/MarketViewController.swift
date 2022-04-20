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
    
    private var btcData: CoinModel? {
        didSet{ self.loadGlobalData() }
    }
    
    @IBOutlet weak var dominanceView: UIView!
    @IBOutlet weak var dominanceLabel: UILabel!
    @IBOutlet weak var dominanceChangeLabel: UILabel!
    @IBOutlet weak var marketCapView: UIView!
    @IBOutlet weak var marketCapLabel: UILabel!
    @IBOutlet weak var marketCapChangeLabel: UILabel!
    @IBOutlet weak var greedAndFearView: UIView!
    @IBOutlet weak var marketTableViewHeader: UIView!
    @IBOutlet weak var marketTableView: UITableView!
    
    @IBAction func refreshClicked(_ sender: Any) {
        loadMarketData()
        marketTableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        marketTableView.dataSource = self
        marketTableView.delegate = self
        
        marketTableView.register(MarketTableCell.nib(), forCellReuseIdentifier: MarketTableCell.identifier)
        
        MarketData.getMarketData()
        
        loadMarketData()
        
        loadGreedAndFearIndex()
        
        marketCapView.configureWithShadow()
        
        dominanceView.configureWithShadow()
    
        greedAndFearView.layer.cornerRadius = 15
        greedAndFearView.backgroundColor = .clouds
        greedAndFearView.layer.shadowOffset = .zero
        greedAndFearView.layer.shadowOpacity = 1
        greedAndFearView.layer.shadowRadius = 12.5
        
        marketTableView.backgroundColor = .clouds
        
        marketTableViewHeader.layer.cornerRadius = 15
        marketTableViewHeader.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        marketTableViewHeader.backgroundColor = .clouds
        
        //Remove NavBar Border
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.layoutIfNeeded()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        guard !tableViewArray.isEmpty else { return }
        
        let topIndex = IndexPath(row: 0, section: 0)
        marketTableView.scrollToRow(at: topIndex, at: .top, animated: false)

    }
 
    private func loadMarketData() {
        APICaller.shared.getMarketData { result in
            switch result {
                
            case .success(let coinArray):
                self.tableViewArray = coinArray
                self.btcData = self.tableViewArray.filter({$0.symbol == "btc"}).first
                
                DispatchQueue.main.async {
                    self.marketTableView.reloadData()
                }
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    //MARK: - Load Global Data
    
    private func loadGlobalData() {
        APICaller.shared.getGlobalData { result in
            switch result {
            case .success(let globalData):
                let marketCap = globalData.totalMarketCap["usd"]
                let marketCapChange = globalData.marketCapChangePercentage24HUsd
                let btcDominance = globalData.marketCapPercentage["btc"]
                
                let btcDominanceChange = GlobalData.calculateDominanceChange(
                    todayDominance: btcDominance ?? 0,
                    totalMarketCap: marketCap ?? 0,
                    totalMarketCapChange: marketCapChange,
                    btcMarketCap: self.btcData?.marketCap ?? 0,
                    btcMarketCapChange: self.btcData?.marketCapChange24H ?? 0)
                
                DispatchQueue.main.async {
                    
                    self.marketCapLabel.text = ((marketCap ?? 0)/1000000000000).string2f() + " T"
                    if marketCapChange >= 0 {
                        self.marketCapChangeLabel.text = "+" + marketCapChange.string2f() + "%"
                        self.marketCapChangeLabel.textColor = .nephritis
                    } else {
                        self.marketCapChangeLabel.text = marketCapChange.string2f() + "%"
                        self.marketCapChangeLabel.textColor = .pomergranate
                    }
            
                    self.dominanceLabel.text = btcDominance?.string2f() ?? "" + "%"
                    
                    if btcDominanceChange >= 0 {
                        
                        self.dominanceChangeLabel.text = "+" + btcDominanceChange.string2f() + "%"
                        self.dominanceChangeLabel.textColor = .nephritis
                    } else {
                        self.dominanceChangeLabel.text = btcDominanceChange.string2f() + "%"
                        self.dominanceChangeLabel.textColor = .pomergranate
                    }
                }
                
                
            case .failure(let error):
                fatalError("\(error)")
            }
        }
    }
    
// MARK: - GreedAndFearView
    
    @IBOutlet weak var greedAndFearIndexValueClassification: UILabel!
    @IBOutlet weak var greedAndFearIndexValue: UILabel!
    
    
    private func loadGreedAndFearIndex() {
        APICaller.shared.getGreedAndFearIndex { result in
            switch result {
                
            case .success(let index):
                DispatchQueue.main.async {
                    self.greedAndFearIndexValue.text = index.data[0].value
                    
                    guard let indexValue = Int(index.data[0].value) else {fatalError()}
                    
                    switch indexValue {
                    case 0...24:
                        self.greedAndFearView.layer.shadowColor = UIColor.pomergranate.cgColor
                        self.greedAndFearIndexValueClassification.textColor = .pomergranate
                    case 25...44:
                        self.greedAndFearView.layer.shadowColor = UIColor.alizarin.cgColor
                        self.greedAndFearIndexValueClassification.textColor = .alizarin
                    case 45...54:
                        self.greedAndFearView.layer.shadowColor = UIColor.carrot.cgColor
                        self.greedAndFearIndexValueClassification.textColor = .carrot
                    case 55...74:
                        self.greedAndFearView.layer.shadowColor = UIColor.emerald.cgColor
                        self.greedAndFearIndexValueClassification.textColor = .emerald
                    case 75...100:
                        self.greedAndFearView.layer.shadowColor = UIColor.nephritis.cgColor
                        self.greedAndFearIndexValueClassification.textColor = .nephritis
                    default:
                        fatalError()
                    }
                    
                    self.greedAndFearIndexValueClassification.text = index.data[0].valueClassification
                    
                }
                
            case .failure(let error):
                print(error)
            }
        }
    }
}

//MARK: - Table View Delegate and Data Source
extension MarketViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableViewArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = marketTableView.dequeueReusableCell(withIdentifier: MarketTableCell.identifier, for: indexPath) as! MarketTableCell
        
        let configuredCell = cell.configureCell(with: tableViewArray[indexPath.row])
        
        return  configuredCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        60
    }
    
    func  tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        clickedIndexPath = indexPath
        performSegue(withIdentifier: marketToCoinDetailsSegue, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! CoinDetailsViewController
        destinationVC.coinModel = tableViewArray[clickedIndexPath.row]
    }
}



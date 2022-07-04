//
//  ViewController.swift
//  PortfolioPerformance
//
//  Created by Nataliia Shusta on 09/02/2022.
//

import UIKit

class MarketViewController: UIViewController {
    
    static let shared = MarketViewController()
    
    static var favouritesArray = [String]()
    private var clickedIndexPath = IndexPath()
    public var tableViewArray = [CoinModel]()
    private let marketToCoinDetailsSegue = "marketToCoinDetails"
    private let marketToSearchSegueID = "marketToSearch"
    
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
    
    
    @IBOutlet weak var sortCollectionView: UICollectionView!
    @IBOutlet weak var marketTableView: UITableView!
    
    @IBAction func didClickSearch(_ sender: Any) {
        //let searchVC = SearchScreenViewController()
        //let searchVC = TestVC()
        let searchVC = _New_MarketViewController()
        self.navigationController?.pushViewController(searchVC, animated: true)
    }
    
    @IBAction func refreshClicked(_ sender: Any) {
        loadMarketData()
        marketTableView.reloadData()
    }
    
    private let sortCategories = ["Highest Cap", "Top Winners", "Top Losers", "Top Volume"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        self.tabBarController?.viewControllers![4] = MyPortfolioViewController()
        
        marketTableView.dataSource = self
        marketTableView.delegate = self
        marketTableView.separatorStyle = .none
        
        sortCollectionView.dataSource = self
        sortCollectionView.delegate = self
        
        // Set first cell as selected
        sortCollectionView.selectItem(
            at: IndexPath(row: 0, section: 0),
            animated: false,
            scrollPosition: .left
        )
        
        sortCollectionView.showsHorizontalScrollIndicator = false
        
        marketTableView.register(MarketTableViewCell.self, forCellReuseIdentifier: MarketTableViewCell.identifier)
        
//        sortCollectionView.register(
//            MarketSortCollectionViewCell.self,
//            forCellWithReuseIdentifier: MarketSortCollectionViewCell.identifier
//        )
        
        MarketData.shared.getMarketData()
        
        loadMarketData()
        
        loadGreedAndFearIndex()
        
        marketCapView.configureWithShadow()
        
        dominanceView.configureWithShadow()
        
        greedAndFearView.configureWithShadow()
        
       
        
//        greedAndFearView.layer.cornerRadius = 15
//        greedAndFearView.backgroundColor = .white
//        greedAndFearView.layer.shadowOffset = .zero
//        greedAndFearView.layer.shadowOpacity = 1
//        greedAndFearView.layer.shadowRadius = 12.5
        
        marketTableView.backgroundColor = .white
        marketTableView.layer.cornerRadius = 15
        marketTableView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        
        //Remove NavBar Border
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.layoutIfNeeded()
        
        view.backgroundColor = .secondarySystemBackground
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
                    btcMarketCapChange: self.btcData?.marketCapChange24H ?? 0
                )
                
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
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: MarketTableViewCell.identifier,
            for: indexPath
        ) as? MarketTableViewCell else {
            fatalError()
        }
        cell.configureCell(with: .init(model: tableViewArray[indexPath.row]))
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        MarketTableViewCell.prefferedHeight
    }
    
    func  tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        clickedIndexPath = indexPath
        performSegue(withIdentifier: marketToCoinDetailsSegue, sender: self)
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! CoinDetailsViewController
        destinationVC.coinModel = tableViewArray[clickedIndexPath.row]
    }
}

//MARK: - Collection View Delegate And Data Source

extension MarketViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        sortCategories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = sortCollectionView.dequeueReusableCell(
            withReuseIdentifier: "marketSortCell",
            for: indexPath
        ) as! MarketSortCollectionViewCell
        
        cell.sortNameLabel.text = sortCategories[indexPath.row]
        cell.sortCellView.layer.cornerRadius = 15
//        cell.sortCellView.backgroundColor = .white
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            tableViewArray = tableViewArray.sorted { $0.marketCapRank ?? 0 < $1.marketCapRank ?? 0 }
        case 1:
            tableViewArray = tableViewArray.sorted { $0.priceChangePercentage24H ?? 0 > $1.priceChangePercentage24H ?? 0
            }
        case 2:
            tableViewArray = tableViewArray.sorted { $0.priceChangePercentage24H ?? 0 < $1.priceChangePercentage24H ?? 0 }
        case 3:
            tableViewArray = tableViewArray.sorted { $0.totalVolume ?? 0 > $1.totalVolume ?? 0 }
        default:
            fatalError()
        }
        
        marketTableView.reloadData()
        
        marketTableView.scrollToRow(
            at: IndexPath(row: 0, section: 0),
            at: .top,
            animated: false
        )
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        2
    }
    
    
}




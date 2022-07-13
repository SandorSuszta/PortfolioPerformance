//
//  [New]MarketViewController.swift
//  PortfolioPerformance
//
//  Created by Nataliia Shusta on 16/06/2022.
//

import UIKit

class _New_MarketViewController: UIViewController {
    
    //MARK: - Properties
    
    private let marketCardsViewModel = MarketCardsCollectionViewViewModel()
    private let cryptoCurrencyTableViewModel = CryptoCurrencyTableViewModel()
    private let sortOptionsArray = ["Highest Cap", "Top Winners", "Top Losers", "Top Volume"]
    
    
    private var marketCardsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return collection
    }()
    
    private var sortOptionsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return collection
    }()
    
    
    private let cryptoCurrencyTableView = UITableView()

    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray6
        setupMarketCardsCollectionView()
        setupSortOptionsCollectionView()
        setupTableView()
        bindViewModels()
        cryptoCurrencyTableViewModel.loadAllCryptoCurrenciesData()
        marketCardsViewModel.loadGreedAndFearIndex()
        marketCardsViewModel.loadGlobalData()

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        marketCardsCollectionView.frame = CGRect(
            x: 0,
            y: 100,
            width: view.width,
            height: 170
        )
        
        sortOptionsCollectionView.frame = CGRect(
            x: 0,
            y: marketCardsCollectionView.bottom,
            width: view.width,
            height: 30
        )
        
        cryptoCurrencyTableView.frame = CGRect(
            x: 10,
            y: sortOptionsCollectionView.bottom + 5,
            width: view.width - 20,
            height: view.height - marketCardsCollectionView.height - sortOptionsCollectionView.height -
            (self.tabBarController?.tabBar.frame.height ?? 0) - 105
        )
    }
    
    //MARK: - Methods
    
    //Market Cards Setup
    private func setupMarketCardsCollectionView() {
        marketCardsCollectionView.delegate = self
        marketCardsCollectionView.dataSource = self
        marketCardsCollectionView.backgroundColor = .clear
        marketCardsCollectionView.showsHorizontalScrollIndicator = false
        marketCardsCollectionView.register(
            MarketCardsCollectionViewCell.self,
            forCellWithReuseIdentifier: MarketCardsCollectionViewCell.identifier
        )
        view.addSubview(marketCardsCollectionView)
    }
    
    //Sort Options Setup
    private func setupSortOptionsCollectionView() {
        sortOptionsCollectionView.delegate = self
        sortOptionsCollectionView.dataSource = self
        sortOptionsCollectionView.backgroundColor = .clear
        sortOptionsCollectionView.showsHorizontalScrollIndicator = false
        // Set first option as selected
        sortOptionsCollectionView.selectItem(
            at: IndexPath(row: 0, section: 0),
            animated: false,
            scrollPosition: .left
        )
        sortOptionsCollectionView.register(
            SortOptionsCollectionViewCell.self,
            forCellWithReuseIdentifier: SortOptionsCollectionViewCell.identifier
        )
        view.addSubview(sortOptionsCollectionView)
    }
    
    //Table View Setup
    private func setupTableView() {
        cryptoCurrencyTableView.delegate = self
        cryptoCurrencyTableView.dataSource = self
        cryptoCurrencyTableView.backgroundColor = .systemGray6
        cryptoCurrencyTableView.separatorStyle = .none
        cryptoCurrencyTableView.register(
            CryptoCurrenciesTableViewCell.self,
            forCellReuseIdentifier: CryptoCurrenciesTableViewCell.identifier
        )
        view.addSubview(cryptoCurrencyTableView)
    }
                                                       
                                                       
    private func bindViewModels() {
        cryptoCurrencyTableViewModel.cellViewModels.bind { [weak self] _ in
            DispatchQueue.main.async {
                self?.cryptoCurrencyTableView.reloadData()
            }
        }
        marketCardsViewModel.cardViewModels.bind {[weak self] _ in
            DispatchQueue.main.async {
                self?.marketCardsCollectionView.reloadData()
            }
        }
    }
}
    
    //MARK: - Collection View methods

extension _New_MarketViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == sortOptionsCollectionView {
            //Sort options collection case
            return sortOptionsArray.count
        }
        
        //Market card collection case
        return marketCardsViewModel.cardViewModels.value?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == sortOptionsCollectionView {
            //Sort options collection case
            guard let cell = sortOptionsCollectionView.dequeueReusableCell(
                withReuseIdentifier: SortOptionsCollectionViewCell.identifier,
                for: indexPath
            ) as? SortOptionsCollectionViewCell else { return UICollectionViewCell() }
            
            cell.sortingNameLabel.text = sortOptionsArray[indexPath.row]
            return cell
        }
        
        //Market card collection case
        guard let cell = marketCardsCollectionView.dequeueReusableCell(
            withReuseIdentifier: MarketCardsCollectionViewCell.identifier,
            for: indexPath
        ) as? MarketCardsCollectionViewCell else { return UICollectionViewCell() }
        
        guard let cellViewModel = marketCardsViewModel.cardViewModels.value?[indexPath.row] else { fatalError()}
        cell.configureCard(with: cellViewModel)
        cell.configureWithShadow()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == marketCardsCollectionView {
            //Sort options collection case
            return CGSize(width: view.width/3 - 10 , height: (view.width/3 + 20) )
        }
        //Market card collection case
        return CGSize(width: 90, height: 20)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == sortOptionsCollectionView {
            //Sort options collection case
            sortTableview(option: indexPath.row)
        }
    }
    
    //Distance between the cells
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        10
    }
    
    //Left inset
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
    }
    
    func sortTableview(option: Int) {
        switch option {
        case 0: //Top Market Cap
            cryptoCurrencyTableViewModel.cellViewModels.value?.sort(by: {
                $0.coinModel.marketCap ?? 0 > $1.coinModel.marketCap ?? 0
            })
        case 1: //Top Winners
            cryptoCurrencyTableViewModel.cellViewModels.value?.sort(by: {
                $0.coinModel.priceChangePercentage24H ?? 0 > $1.coinModel.priceChangePercentage24H ?? 0
            })
        case 2: //Top Losers
            cryptoCurrencyTableViewModel.cellViewModels.value?.sort(by: {
                $0.coinModel.priceChangePercentage24H ?? 0 < $1.coinModel.priceChangePercentage24H ?? 0
            })
        case 3: //Top Volume
            cryptoCurrencyTableViewModel.cellViewModels.value?.sort(by: {
                $0.coinModel.totalVolume ?? 0 > $1.coinModel.totalVolume ?? 0
            })
        default:
            fatalError()
        }
    }
}
    //MARK: - Table View Delegate and Data Source Methods
    
extension _New_MarketViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        cryptoCurrencyTableViewModel.cellViewModels.value?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: CryptoCurrenciesTableViewCell.identifier,
            for: indexPath
        ) as? CryptoCurrenciesTableViewCell else { return UITableViewCell() }
        
        guard let cellViewModel = cryptoCurrencyTableViewModel.cellViewModels.value?[indexPath.row] else { fatalError() }
        cell.configureCell(with: cellViewModel)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        CryptoCurrenciesTableViewCell.prefferedHeight
    }
}
    
    



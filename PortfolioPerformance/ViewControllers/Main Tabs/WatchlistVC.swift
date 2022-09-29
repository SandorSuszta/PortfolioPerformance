//
//  WatchlistViewController2.swift
//  PortfolioPerformance
//
//  Created by Nataliia Shusta on 10/07/2022.
//

import Foundation
import UIKit

class WatchlistViewController: UIViewController {

    private let tableViewModel = WatchlistTableViewModel()

    private let watchlistTableView = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray6
        self.title = "Watchlist"
        setupTableView()
        bindViewModel()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateTableWithWatchlist()
        tableViewModel.loadWatchlistCryptoCurrenciesData()
    }
    
    override func viewDidLayoutSubviews() {
        watchlistTableView.frame = CGRect(
            x: 15,
            y: 100,
            width: view.width - 30,
            height: view.height - 80
        )
    }
    
    private func setupTableView() {
        watchlistTableView.delegate = self
        watchlistTableView.dataSource = self
        watchlistTableView.backgroundColor = .clear
        watchlistTableView.separatorStyle = .none
        watchlistTableView.register(
            CryptoCurrenciesTableViewCell.self,
            forCellReuseIdentifier: CryptoCurrenciesTableViewCell.identifier
        )
        view.addSubview(watchlistTableView)
    }
    
    private func updateTableWithWatchlist() {
        tableViewModel.loadWatchlistCryptoCurrenciesData()
    }
    
    private func bindViewModel() {
        tableViewModel.cellViewModels.bind { [weak self] models in
            DispatchQueue.main.async {
                self?.watchlistTableView.reloadData()
            }
        }
    }
}

    //MARK: - Table view delegate and data source
    extension WatchlistViewController: UITableViewDelegate, UITableViewDataSource {
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            tableViewModel.cellViewModels.value?.count ?? 0
        }

        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: CryptoCurrenciesTableViewCell.identifier,
                for: indexPath
            ) as? CryptoCurrenciesTableViewCell else { return UITableViewCell() }
            
            guard let cellViewModel = tableViewModel.cellViewModels.value?[indexPath.row] else { fatalError() }
            
            cell.configureCell(with: cellViewModel)
            
            return cell
        }

        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            CryptoCurrenciesTableViewCell.prefferedHeight
        }
        
        func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
            if editingStyle == .delete {
                guard let ID = tableViewModel.cellViewModels.value?[indexPath.row].coinModel.id else { fatalError() }
                
                tableView.beginUpdates()
                WatchlistManager.shared.deleteFromWatchlist(ID: ID)
                tableViewModel.cellViewModels.value?.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .left)
                tableView.endUpdates()
            }
        }
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            
            guard let currentCoinModel = tableViewModel.cellViewModels.value?[indexPath.row].coinModel else { fatalError("Cant get coinModel in WatclistVC")}
            
            
            let detailsVC = DetailVC(coinID: currentCoinModel.id, coinName: currentCoinModel.name, coinSymbol: currentCoinModel.symbol, logoURL: currentCoinModel.image)
            
            self.navigationController?.pushViewController(detailsVC, animated: true)
        }
       
    }


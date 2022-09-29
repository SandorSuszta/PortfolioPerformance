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
    
    private let emptyWatchlistLabel: UILabel = {
        let label = UILabel()
        label.text = "Watchlist is empty..."
        label.font = .systemFont(ofSize: 26, weight: .bold)
        label.textColor = .secondaryLabel
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray6
        self.title = "Watchlist"
        setupTableView()
        bindViewModel()
        
        //Delete BackButton title on pushed screen
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateTableWithWatchlist()
    }
    
    override func viewDidLayoutSubviews() {
        
        watchlistTableView.frame = CGRect(
            x: 15,
            y: 100,
            width: view.width - 30,
            height: view.height - 80
        )
        
        view.addSubview(emptyWatchlistLabel)
        emptyWatchlistLabel.sizeToFit()
        emptyWatchlistLabel.frame = CGRect(
            x: view.width / 2 - emptyWatchlistLabel.width / 2,
            y: view.height / 2 - emptyWatchlistLabel.height / 2,
            width: emptyWatchlistLabel.width,
            height: emptyWatchlistLabel.height
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
        if WatchlistManager.shared.watchlistIDs.isEmpty {
            emptyWatchlistLabel.isHidden = false
        } else {
            emptyWatchlistLabel.isHidden = true
            tableViewModel.loadWatchlistCryptoCurrenciesData(
                list: WatchlistManager.shared.watchlistIDs
            )
        }
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
                
                if WatchlistManager.shared.watchlistIDs.isEmpty {
                    emptyWatchlistLabel.isHidden = false
                }
            }
        }
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            
            guard let currentCoinModel = tableViewModel.cellViewModels.value?[indexPath.row].coinModel else { fatalError("Cant get coinModel in WatclistVC")}
            
            let detailsVC = DetailVC(
                coinID: currentCoinModel.id,
                coinName: currentCoinModel.name,
                coinSymbol: currentCoinModel.symbol,
                logoURL: currentCoinModel.image,
                isFavourite: WatchlistManager.shared.isInWatchlist(id: currentCoinModel.id)
            )
            
            self.navigationController?.pushViewController(detailsVC, animated: true)
        }
       
    }


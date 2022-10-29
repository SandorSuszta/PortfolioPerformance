//
//  WatchlistViewController.swift
//  PortfolioPerformance
//
//  Created by Sandor Suszta on 10/07/2022.
//

import UIKit

class WatchlistViewController: UIViewController {

    private let watchlistVM = WatchlistViewModel()

    private let watchlistTableView = UITableView()
    
    private let emptyWatchlistLabel: UILabel = {
        let label = UILabel()
        label.text = "Watchlist is empty..."
        label.font = .systemFont(ofSize: 26, weight: .bold)
        label.textColor = .secondaryLabel
        return label
    }()

    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupVC()
        setupTableView()
        bindViewModel()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateTableWithWatchlist()
    }
    
    override func viewDidLayoutSubviews() {
        layoutComponents()
    }
    
    //MARK: - Private methods
    
    private func setupVC() {
        view.backgroundColor = .systemGray6
        self.title = "Watchlist"
        
        //Delete BackButton title on pushed screen
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    private func setupTableView() {
        view.addSubview(watchlistTableView)
        
        watchlistTableView.delegate = self
        watchlistTableView.dataSource = self
        watchlistTableView.backgroundColor = .clear
        watchlistTableView.separatorStyle = .none
        watchlistTableView.register(
            CryptoCurrenciesTableViewCell.self,
            forCellReuseIdentifier: CryptoCurrenciesTableViewCell.identifier
        )
    }
    
    private func updateTableWithWatchlist() {
        if UserDefaultsManager.shared.watchlistIDs.isEmpty {
            watchlistVM.cellViewModels.value = []
            emptyWatchlistLabel.isHidden = false
        } else {
            emptyWatchlistLabel.isHidden = true
            watchlistVM.loadWatchlistCryptoCurrenciesData(
                list: UserDefaultsManager.shared.watchlistIDs
            )
        }
    }
    
    private func bindViewModel() {
        watchlistVM.cellViewModels.bind { [weak self] models in
            DispatchQueue.main.async {
                self?.watchlistTableView.reloadData()
            }
        }
        
        watchlistVM.errorMessage?.bind { [weak self] message in
            self?.showAlert(message: message ?? "An error has occured")
        }
    }
    
    private func layoutComponents() {
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
}

    //MARK: - Table view delegate and data source

    extension WatchlistViewController: UITableViewDelegate, UITableViewDataSource {
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            watchlistVM.cellViewModels.value?.count ?? 0
        }

        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: CryptoCurrenciesTableViewCell.identifier,
                for: indexPath
            ) as? CryptoCurrenciesTableViewCell else { return UITableViewCell() }
            
            guard let cellViewModel = watchlistVM.cellViewModels.value?[indexPath.row] else { fatalError() }
            
            cell.configureCell(with: cellViewModel)
            
            return cell
        }

        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            CryptoCurrenciesTableViewCell.prefferedHeight
        }
        
        func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
            if editingStyle == .delete {
                guard let ID = watchlistVM.cellViewModels.value?[indexPath.row].coinModel.id else { fatalError() }
                
                tableView.beginUpdates()
                
                UserDefaultsManager.shared.deleteFromDefaults(
                    ID: ID,
                    for: UserDefaultsManager.shared.watchlistKey
                )
                
                watchlistVM.cellViewModels.value?.remove(at: indexPath.row)
                
                tableView.deleteRows(at: [indexPath], with: .left)
                
                tableView.endUpdates()
                
                if UserDefaultsManager.shared.watchlistIDs.isEmpty {
                    emptyWatchlistLabel.isHidden = false
                }
            }
        }
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            
            guard let currentCoinModel = watchlistVM.cellViewModels.value?[indexPath.row].coinModel else { fatalError("Cant get coinModel in WatclistVC")}
            
            let detailsVC = CoinDetailsVC(
                coinID: currentCoinModel.id,
                coinName: currentCoinModel.name,
                coinSymbol: currentCoinModel.symbol,
                logoURL: currentCoinModel.image,
                isFavourite: UserDefaultsManager.shared.isInWatchlist(id: currentCoinModel.id)
            )
            
            self.navigationController?.pushViewController(detailsVC, animated: true)
        }
    }

//
//  WatchlistViewController2.swift
//  PortfolioPerformance
//
//  Created by Nataliia Shusta on 10/07/2022.
//

import Foundation
import UIKit

class WatchlistViewController2: UIViewController {

    private let tableViewModel = WatchlistTableViewModel()

    private let watchlistTableView = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray6
        
        setupTableView()
        tableViewModel.loadWatchlistCryptoCurrenciesData()
        
        tableViewModel.cellViewModels.bind { [weak self] _ in
            DispatchQueue.main.async {
                self?.watchlistTableView.reloadData()
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        watchlistTableView.frame = CGRect(
            x: 15,
            y: 5,
            width: view.width - 30,
            height: view.height
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
}

    //MARK: - Table view delegate and data source
    extension WatchlistViewController2: UITableViewDelegate, UITableViewDataSource {
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
    }


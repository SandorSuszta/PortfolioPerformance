import UIKit

class WatchlistViewController: UIViewController {

    private let watchlistVM = WatchlistViewModel()

    private let watchlistTableView = UITableView()

    private let emptyWatchlistView = EmptyStateView(type: .noFavourites)
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupVC()
        setupTableView()
        setupConstraints()
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
        view.backgroundColor = .secondarySystemBackground
        view.addSubview(emptyWatchlistView)
        
        //Delete BackButton title on pushed screen
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    private func setupTableView() {
        view.addSubview(watchlistTableView)
        
        watchlistTableView.delegate = self
        watchlistTableView.dataSource = self
        watchlistTableView.backgroundColor = .clear
        watchlistTableView.separatorStyle = .none
        watchlistTableView.layer.cornerRadius = 10
        
        watchlistTableView.register(
            CryptoCurrencyCell.self,
            forCellReuseIdentifier: CryptoCurrencyCell.identifier
        )
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            emptyWatchlistView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyWatchlistView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            emptyWatchlistView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1 / 2),
            emptyWatchlistView.heightAnchor.constraint(equalTo: emptyWatchlistView.widthAnchor)
        ])
    }
    
    private func updateTableWithWatchlist() {
        if UserDefaultsManager.shared.watchlistIDs.isEmpty {
            watchlistVM.cellViewModels.value = []
            emptyWatchlistView.isHidden = false
        } else {
            emptyWatchlistView.isHidden = true
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
    }
}

    //MARK: - Table view delegate and data source

    extension WatchlistViewController: UITableViewDelegate, UITableViewDataSource {
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            watchlistVM.cellViewModels.value?.count ?? 0
        }

        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: CryptoCurrencyCell.identifier,
                for: indexPath
            ) as? CryptoCurrencyCell else { return UITableViewCell() }
            
            guard let cellViewModel = watchlistVM.cellViewModels.value?[indexPath.row] else { fatalError() }
            
            cell.configureCell(with: cellViewModel)
            
            return cell
        }

        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            view.height / 15
        }
        
        func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
            if editingStyle == .delete {
                guard let ID = watchlistVM.cellViewModels.value?[indexPath.row].coinModel.id else { fatalError() }
                
                UserDefaultsManager.shared.deleteFromDefaults(
                    ID: ID,
                    forKey: DefaultsKeys.watchlist.rawValue
                )
                
                watchlistVM.cellViewModels.value?.remove(at: indexPath.row)
                
                tableView.deleteRows(at: [indexPath], with: .left)
                
                if UserDefaultsManager.shared.watchlistIDs.isEmpty {
                    emptyWatchlistView.isHidden = false
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
        
        func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
            
            let section = indexPath.section
            let row = indexPath.row
            let numRowsInSection = tableView.numberOfRows(inSection: section)
            
            if row == numRowsInSection - 1 {
                if let resultsCell = cell as? CryptoCurrencyCell {
                    resultsCell.makeBottomCornersWithRadius()
                }
            }
        }
    }

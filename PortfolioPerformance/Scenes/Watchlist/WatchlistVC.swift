import UIKit

class WatchlistViewController: UIViewController {
    
    private lazy var dataSource: WatchlistDataSource = makeDataSource()

    private lazy var watchlistTableView = UITableView(frame: .zero, style: .insetGrouped)
    
    private var watchlistVM = WatchlistViewModel(networkingService: NetworkingService())

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
    
    //MARK: - Private methods
    
    private func setupVC() {
        view.addSubview(emptyWatchlistView)
        view.backgroundColor = .secondarySystemBackground
        navigationItem.title = "Watchlist"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        //Delete BackButton title on pushed screen
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Edit", style: .plain, target: self, action: #selector(didTapEdit)
        )
    }
    
    
    
    private func setupTableView() {
        view.addSubview(watchlistTableView)
        
        watchlistTableView.delegate = self
        watchlistTableView.backgroundColor = .clear
        watchlistTableView.separatorStyle = .none
        watchlistTableView.layer.cornerRadius = 10
        watchlistTableView.tableHeaderView = nil
        watchlistTableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: view.width / 20))
        watchlistTableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        watchlistTableView.translatesAutoresizingMaskIntoConstraints = false
        
        watchlistTableView.register(
            CryptoCurrencyCell.self,
            forCellReuseIdentifier: CryptoCurrencyCell.identifier
        )
    }
    
    private func setupConstraints() {
        
        NSLayoutConstraint.activate([
            watchlistTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            watchlistTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            watchlistTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            watchlistTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            emptyWatchlistView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyWatchlistView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            emptyWatchlistView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1 / 2),
            emptyWatchlistView.heightAnchor.constraint(equalTo: emptyWatchlistView.widthAnchor)
        ])
    }
    
    private func updateTableWithWatchlist() {
        if UserDefaultsService.shared.watchlistIDs.isEmpty {
            watchlistVM.cellViewModels.value = []
            emptyWatchlistView.isHidden = false
        } else {
            emptyWatchlistView.isHidden = true
            watchlistVM.loadWatchlistCryptoCurrenciesData(
                list: UserDefaultsService.shared.watchlistIDs
            )
        }
    }
    
    private func bindViewModel() {
        watchlistVM.cellViewModels.bind { [weak self] models in
            guard let self else { return }
            
            DispatchQueue.main.async {
                self.reloadData()
            }
        }
        
        watchlistVM.errorMessage?.bind { [weak self] message in
            self?.showAlert(message: message ?? "An error has occured")
        }
    }
    
    @objc func didTapEdit() {
        watchlistTableView.isEditing = true
    }
}

    //MARK: - TableView DataSource
private extension WatchlistViewController {
    
    typealias WatchlistSnapshot = NSDiffableDataSourceSnapshot<WatchlistSection, CoinModel>
    
    func makeDataSource() -> WatchlistDataSource {
        
        let dataSource = WatchlistDataSource(tableView: watchlistTableView) { tableView, indexPath, itemIdentifier in
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: CryptoCurrencyCell.identifier,
                for: indexPath
            ) as? CryptoCurrencyCell else { return UITableViewCell() }
            
            guard let cellViewModel = self.watchlistVM.cellViewModels.value?[indexPath.row] else { fatalError() }
            
            cell.imageDownloader = ImageDownloader()
            cell.configureCell(with: cellViewModel)
            
            return cell
        }
        
        dataSource.defaultRowAnimation = .automatic
        return dataSource
    }
    
    func makeSnapshot() -> WatchlistSnapshot {
        let coinModels = watchlistVM.cellViewModels.value?.map({ $0.coinModel })
        var snapshot = WatchlistSnapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(coinModels ?? [], toSection: .main)
        return snapshot
    }
    
    func reloadData() {
        dataSource.apply(makeSnapshot(), animatingDifferences: true)
    }
    
}

    //MARK: - TableView Delegate
extension WatchlistViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let currentCoinModel = watchlistVM.cellViewModels.value?[indexPath.row].coinModel else { fatalError("Cant get coinModel in WatclistVC")}
        
        let detailsVC = CoinDetailsVC(
            coinID: currentCoinModel.id,
            coinName: currentCoinModel.name,
            coinSymbol: currentCoinModel.symbol,
            logoURL: currentCoinModel.image,
            isFavourite: UserDefaultsService.shared.isInWatchlist(id: currentCoinModel.id)
        )
        
        self.navigationController?.pushViewController(detailsVC, animated: true)
    }
}

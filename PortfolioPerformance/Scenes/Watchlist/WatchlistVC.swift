import UIKit

class WatchlistViewController: UIViewController {
    
    private let watchlistStore: WatchlistStoreProtocol
    
    private let coordinator: Coordinator
    
    private lazy var dataSource: WatchlistDataSource = makeDataSource()
    
    private lazy var watchlistTableView = UITableView(frame: .zero, style: .insetGrouped)
    
    private var watchlistVM = WatchlistViewModel(networkingService: NetworkingService())
    
    private let emptyWatchlistView = EmptyStateView(type: .noFavourites)
    
    private let feedbackGenerator = UIImpactFeedbackGenerator(style: .light)
    
    private lazy var plusButton: PPRoundedButton = {
        let button = PPRoundedButton(type: .custom)
        button.setImage(UIImage(named: ImageNames.plus), for: .normal)
        button.addTarget(self, action: #selector(plusButtonPressed), for: .touchUpInside)
        return button
    }()
    
    //MARK: - Init
    
    init(coordinator: WatchlistCoordinator, watchlistStore: WatchlistStoreProtocol) {
        self.coordinator = coordinator
        self.watchlistStore = watchlistStore
        super .init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewHierarchy()
        configureVC()
        configureNavigationController()
        setupTableView()
        setupConstraints()
        bindViewModel()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateTableWithWatchlist()
    }
    
    //MARK: - Private methods
    private func configureViewHierarchy() {
        view.addSubviews(
            emptyWatchlistView,
            watchlistTableView,
            plusButton
        )
    }
    
    private func configureVC() {
        view.backgroundColor = .secondarySystemBackground
    }
    
    private func configureNavigationController() {
        
        navigationItem.title = "Watchlist"
        //navigationController?.navigationBar.prefersLargeTitles = true
        
        //Delete BackButton title on pushed screen
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: .init(systemName: "pencil"),
            style: .plain,
            target: self,
            action: #selector(didToggleEdit))
    }
    
    private func setupTableView() {
        
        watchlistTableView.delegate = self
        watchlistTableView.backgroundColor = .clear
        watchlistTableView.separatorStyle = .singleLine
        watchlistTableView.separatorInset = .zero
        watchlistTableView.separatorColor = .secondarySystemBackground
        watchlistTableView.layer.cornerRadius = 10
        watchlistTableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: view.width / 20))
        watchlistTableView.translatesAutoresizingMaskIntoConstraints = false
        
        watchlistTableView.register(
            CryptoCurrencyCell.self,
            forCellReuseIdentifier: CryptoCurrencyCell.identifier
        )
        
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        
        watchlistTableView.addGestureRecognizer(longPressRecognizer)
    }
    
    private func setupConstraints() {
        plusButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            watchlistTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            watchlistTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            watchlistTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            watchlistTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            emptyWatchlistView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyWatchlistView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            emptyWatchlistView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1 / 2),
            emptyWatchlistView.heightAnchor.constraint(equalTo: emptyWatchlistView.widthAnchor),
            
            plusButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            plusButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            plusButton.widthAnchor.constraint(equalToConstant: 64),
            plusButton.heightAnchor.constraint(equalToConstant: 64)
        ])
    }
    
    private func updateTableWithWatchlist() {
        if watchlistStore.getWatchlist().isEmpty {
            watchlistVM.cellViewModels.value = []
            emptyWatchlistView.isHidden = false
        } else {
            emptyWatchlistView.isHidden = true
            watchlistVM.loadWatchlistDataIfNeeded(
                watchlist: watchlistStore.getWatchlist()
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
        
//        watchlistVM.errorMessage?.bind { [weak self] message in
//            //self?.showAlert(message: message ?? "An error has occured")
//        }
    }
    
    @objc private func plusButtonPressed() {
        if let coordinator = coordinator as? WatchlistCoordinator {
            coordinator.showSearch()
        }
    }
    
    @objc func didToggleEdit() {
        watchlistTableView.setEditing(!watchlistTableView.isEditing, animated: true)
        navigationItem.rightBarButtonItem?.image = watchlistTableView.isEditing ? UIImage(systemName: "checkmark") : UIImage(systemName: "pencil")
    }
    
    @objc func handleLongPress(_ gestureRecognizer: UILongPressGestureRecognizer) {
        if gestureRecognizer.state == .began {
            navigationItem.rightBarButtonItem?.image = UIImage(systemName: "checkmark")
            feedbackGenerator.impactOccurred()
            watchlistTableView.setEditing(true, animated: true)
        }
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
        dataSource.didReorderCells = { sourceIndexPath, destinationIndexPath in
        
            self.watchlistVM.reorderCellViewModels(from: sourceIndexPath, to: destinationIndexPath)
            self.watchlistStore.reorderWatchlist(sourceIndex: sourceIndexPath.row, destinationIndex: destinationIndexPath.row)
            dataSource.apply(self.makeSnapshot(), animatingDifferences: true)
        }
        
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        CryptoCurrencyCell.prefferredHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let currentCoinModel = watchlistVM.cellViewModels.value?[indexPath.row].coinModel else { fatalError("Cant get coinModel in WatclistVC")}
        
        if let coordinator = self.coordinator as? WatchlistCoordinator {
            coordinator.showDetails(for: currentCoinModel)
        }
    }
}
